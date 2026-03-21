import { Injectable, NotFoundException } from '@nestjs/common';
import type { LlmExtractionInterface } from '../../../common/interfaces/transport/llm-extraction.interface';
import type { QuoteContextInterface } from '../../../common/interfaces/transport/quote-context.interface';
import { LlmService } from '../../llm/llm.service';
import { PricingService } from '../../pricing/pricing.service';
import { QuoteOptionEntity } from '../../quote/entities/quote-option.entity';
import { QuoteRequestEntity } from '../../quote/entities/quote-request.entity';
import { QuoteService } from '../../quote/quote.service';
import { RulesService } from '../../rules/rules.service';
import { WizardService } from '../../wizard/wizard.service';

@Injectable()
export class ConversationOrchestratorService {
  constructor(
    private readonly llmService: LlmService,
    private readonly wizardService: WizardService,
    private readonly quoteService: QuoteService,
    private readonly rulesService: RulesService,
    private readonly pricingService: PricingService,
  ) {}

  async processUserMessage(params: {
    sessionId: string;
    userId: string;
    userMessage: string;
    messageHistory: Array<{ role: string; content: string }>;
  }) {
    await this.wizardService.initializeSessionSteps(params.sessionId);

    const quoteRequest =
      await this.quoteService.findOrCreateByConversationSessionId(
        params.sessionId,
      );

    const extraction = await this.extractConversationData(params);

    await this.persistWizardStates(params.sessionId, extraction);

    const updatedQuoteRequest = await this.quoteService.upsertFromExtraction(
      quoteRequest.id,
      extraction,
    );

    if (!updatedQuoteRequest) {
      throw new NotFoundException(
        `No se ha podido actualizar la solicitud de presupuesto ${quoteRequest.id}`,
      );
    }

    const wizardStates = await this.wizardService.getSessionStepStates(
      params.sessionId,
    );

    const missingFields = this.getMissingCoreFields(updatedQuoteRequest);

    let validationSummary: Record<string, unknown> | null = null;
    let topOption: QuoteOptionEntity | null = null;

    if (missingFields.length === 0) {
      validationSummary = await this.rulesService.validateQuoteRequest(
        updatedQuoteRequest.id,
        {
          clearPreviousResults: true,
        },
      );

      const failed = Array.isArray(validationSummary.results)
        ? validationSummary.results.some(
            (item: { validationStatus?: string }) =>
              item.validationStatus === 'failed',
          )
        : false;

      if (!failed) {
        topOption = await this.pricingService.calculateBestOption(
          updatedQuoteRequest.id,
        );
      }
    }

    const refreshedQuoteRequest =
      await this.quoteService.getQuoteRequestEntityById(updatedQuoteRequest.id);

    const context: QuoteContextInterface = {
      quoteRequest: refreshedQuoteRequest,
      wizardStates,
      topOption,
      missingFields,
    };

    const assistantMessage = this.buildAssistantMessage({
      extraction,
      context,
      validationSummary,
    });

    return {
      extraction,
      context,
      validationSummary,
      assistantMessage,
    };
  }

  private async extractConversationData(params: {
    userId: string;
    userMessage: string;
    messageHistory: Array<{ role: string; content: string }>;
  }): Promise<LlmExtractionInterface> {
    const historyText = params.messageHistory
      .slice(-8)
      .map((message) => `${message.role.toUpperCase()}: ${message.content}`)
      .join('\n');

    const prompt = `
Eres un extractor de datos para un wizard de transporte de líquidos.

Debes devolver EXCLUSIVAMENTE JSON válido.


por cierto, en adelante usarás yarn para las instalaciones, no npm

Extrae estos campos:
- productText
- quantityValue
- quantityUnit
- originText
- destinationText
- requestedPickupAt
- deliveryDeadlineAt

Reglas:
- Si un dato no aparece, usa null.
- requestedPickupAt y deliveryDeadlineAt deben ir en ISO 8601 si se pueden inferir con suficiente seguridad.
- missingFields debe incluir solo:
  ["product","quantity","origin","destination","requested_date","delivery_deadline"]
- nextBestQuestion debe ser una pregunta concreta y contextual en español de España, mencionando exactamente los datos que faltan y evitando frases genéricas.
- confidence debe ser un número entre 0 y 1.

Historial:
${historyText}

Mensaje:
${params.userMessage}

Formato:
{
  "intent": "create_or_update_quote_request",
  "extractedFields": {
    "productText": null,
    "quantityValue": null,
    "quantityUnit": null,
    "originText": null,
    "destinationText": null,
    "requestedPickupAt": null,
    "deliveryDeadlineAt": null
  },
  "missingFields": [],
  "nextBestQuestion": null,
  "confidence": 0.0
}
`.trim();

    const response = await this.llmService.generateText(
      {
        prompt,
        actionType: 'wizard_data_extraction',
      },
      params.userId,
    );

    return this.parseExtractionResponse(response.text);
  }

  private parseExtractionResponse(text: string): LlmExtractionInterface {
    try {
      const firstBrace = text.indexOf('{');
      const lastBrace = text.lastIndexOf('}');
      const cleaned = text.slice(firstBrace, lastBrace + 1);
      const parsed = JSON.parse(cleaned) as LlmExtractionInterface;

      return {
        intent: parsed.intent ?? 'create_or_update_quote_request',
        extractedFields: {
          productText: parsed.extractedFields?.productText ?? null,
          quantityValue: parsed.extractedFields?.quantityValue ?? null,
          quantityUnit: parsed.extractedFields?.quantityUnit ?? null,
          originText: parsed.extractedFields?.originText ?? null,
          destinationText: parsed.extractedFields?.destinationText ?? null,
          requestedPickupAt: parsed.extractedFields?.requestedPickupAt ?? null,
          deliveryDeadlineAt:
            parsed.extractedFields?.deliveryDeadlineAt ?? null,
        },
        missingFields: Array.isArray(parsed.missingFields)
          ? parsed.missingFields
          : [],
        nextBestQuestion: parsed.nextBestQuestion ?? null,
        confidence:
          typeof parsed.confidence === 'number' ? parsed.confidence : null,
      };
    } catch {
      return {
        intent: 'create_or_update_quote_request',
        extractedFields: {
          productText: null,
          quantityValue: null,
          quantityUnit: null,
          originText: null,
          destinationText: null,
          requestedPickupAt: null,
          deliveryDeadlineAt: null,
        },
        missingFields: [
          'product',
          'quantity',
          'origin',
          'destination',
          'requested_date',
          'delivery_deadline',
        ],
        nextBestQuestion:
          'Necesito algunos datos más para preparar el presupuesto. ¿Qué producto transportas, qué cantidad es, desde dónde, hasta dónde, para qué fecha y con qué límite de entrega?',
        confidence: 0.1,
      };
    }
  }

  private async persistWizardStates(
    sessionId: string,
    extraction: LlmExtractionInterface,
  ) {
    if (extraction.extractedFields.productText) {
      await this.wizardService.upsertSessionStepState(sessionId, 'product', {
        status: 'completed',
        rawValueText: extraction.extractedFields.productText,
        valueJson: { productText: extraction.extractedFields.productText },
      });
    }

    if (
      extraction.extractedFields.quantityValue !== null &&
      typeof extraction.extractedFields.quantityValue !== 'undefined'
    ) {
      await this.wizardService.upsertSessionStepState(sessionId, 'quantity', {
        status: 'completed',
        rawValueText: `${extraction.extractedFields.quantityValue} ${extraction.extractedFields.quantityUnit ?? 'L'}`,
        valueJson: {
          quantityValue: extraction.extractedFields.quantityValue,
          quantityUnit: extraction.extractedFields.quantityUnit ?? 'L',
        },
      });
    }

    if (extraction.extractedFields.originText) {
      await this.wizardService.upsertSessionStepState(sessionId, 'origin', {
        status: 'completed',
        rawValueText: extraction.extractedFields.originText,
        valueJson: { originText: extraction.extractedFields.originText },
      });
    }

    if (extraction.extractedFields.destinationText) {
      await this.wizardService.upsertSessionStepState(
        sessionId,
        'destination',
        {
          status: 'completed',
          rawValueText: extraction.extractedFields.destinationText,
          valueJson: {
            destinationText: extraction.extractedFields.destinationText,
          },
        },
      );
    }

    if (extraction.extractedFields.requestedPickupAt) {
      await this.wizardService.upsertSessionStepState(
        sessionId,
        'requested_date',
        {
          status: 'completed',
          rawValueText: extraction.extractedFields.requestedPickupAt,
          valueJson: {
            requestedPickupAt: extraction.extractedFields.requestedPickupAt,
          },
        },
      );
    }

    if (extraction.extractedFields.deliveryDeadlineAt) {
      await this.wizardService.upsertSessionStepState(
        sessionId,
        'delivery_deadline',
        {
          status: 'completed',
          rawValueText: extraction.extractedFields.deliveryDeadlineAt,
          valueJson: {
            deliveryDeadlineAt: extraction.extractedFields.deliveryDeadlineAt,
          },
        },
      );
    }
  }

  private getMissingCoreFields(quoteRequest: QuoteRequestEntity): string[] {
    const missing: string[] = [];

    if (
      !quoteRequest.requestedProductText ||
      quoteRequest.requestedProductText === 'Pendiente'
    ) {
      missing.push('product');
    }
    if (!quoteRequest.requestedVolumeLiters) {
      missing.push('quantity');
    }
    if (!quoteRequest.originText) {
      missing.push('origin');
    }
    if (!quoteRequest.destinationText) {
      missing.push('destination');
    }
    if (!quoteRequest.requestedLoadDate) {
      missing.push('requested_date');
    }
    if (!quoteRequest.deliveryDeadlineDatetime) {
      missing.push('delivery_deadline');
    }

    return missing;
  }

  private buildAssistantMessage(params: {
    extraction: LlmExtractionInterface;
    context: QuoteContextInterface;
    validationSummary: Record<string, unknown> | null;
  }): string {
    if (params.context.missingFields.length > 0) {
      return this.buildMissingDataPrompt(
        params.extraction,
        params.context.missingFields,
      );
    }

    const failed = Array.isArray(params.validationSummary?.results)
      ? params.validationSummary.results.some(
          (item: { validationStatus?: string }) =>
            item.validationStatus === 'failed',
        )
      : false;

    if (failed) {
      const failedMessages = Array.isArray(params.validationSummary?.results)
        ? params.validationSummary.results
            .filter(
              (item: { validationStatus?: string }) =>
                item.validationStatus === 'failed',
            )
            .map((item: { message?: string | null }) => item.message)
            .filter(
              (message): message is string =>
                typeof message === 'string' && message.trim().length > 0,
            )
        : [];

      const uniqueMessages = Array.from(new Set(failedMessages));

      if (uniqueMessages.length === 1) {
        return `He podido completar la solicitud, pero hay un punto que impide validarla: ${uniqueMessages[0]} ¿Puedes revisarlo?`;
      }

      if (uniqueMessages.length > 1) {
        const formatted = uniqueMessages
          .map((message) =>
            message.endsWith('.') ? message.slice(0, -1) : message,
          )
          .join('; ');

        return `He podido completar la solicitud, pero hay varios puntos que impiden validarla: ${formatted}. ¿Puedes revisarlos?`;
      }

      return 'He podido completar la solicitud, pero hay puntos que impiden validarla. ¿Puedes revisarlos?';
    }

    if (params.context.topOption) {
      const option = params.context.topOption as {
        estimatedCost?: number | null;
        estimatedTransitHours?: number | null;
      };

      return `Ya tengo todos los datos y he generado una opción recomendada. Coste estimado: ${option.estimatedCost ?? 'N/D'} €. Tránsito estimado: ${option.estimatedTransitHours ?? 'N/D'} horas.`;
    }

    return 'Ya tengo todos los datos principales de la solicitud.';
  }

  private buildMissingDataPrompt(
    extraction: LlmExtractionInterface,
    missingFields: string[],
  ): string {
    const understood: string[] = [];

    if (extraction.extractedFields.productText) {
      understood.push(`producto: ${extraction.extractedFields.productText}`);
    }

    if (
      extraction.extractedFields.quantityValue !== null &&
      typeof extraction.extractedFields.quantityValue !== 'undefined'
    ) {
      understood.push(
        `cantidad: ${extraction.extractedFields.quantityValue} ${extraction.extractedFields.quantityUnit ?? 'L'}`,
      );
    }

    if (extraction.extractedFields.originText) {
      understood.push(`origen: ${extraction.extractedFields.originText}`);
    }

    if (extraction.extractedFields.destinationText) {
      understood.push(`destino: ${extraction.extractedFields.destinationText}`);
    }

    if (extraction.extractedFields.requestedPickupAt) {
      understood.push(
        `fecha de recogida: ${extraction.extractedFields.requestedPickupAt}`,
      );
    }

    if (extraction.extractedFields.deliveryDeadlineAt) {
      understood.push(
        `límite de entrega: ${extraction.extractedFields.deliveryDeadlineAt}`,
      );
    }

    const labels: Record<string, string> = {
      product: 'el producto',
      quantity: 'la cantidad',
      origin: 'el origen',
      destination: 'el destino',
      requested_date: 'la fecha de recogida',
      delivery_deadline: 'el límite de entrega',
    };

    const missingReadable = missingFields.map(
      (field) => labels[field] ?? field,
    );

    const intro =
      understood.length > 0 ? `He entendido ${understood.join(', ')}. ` : '';

    if (missingReadable.length === 1) {
      return `${intro}Me falta ${missingReadable[0]}.`;
    }

    if (missingReadable.length === 2) {
      return `${intro}Me faltan ${missingReadable[0]} y ${missingReadable[1]}. ¿Me los indicas?`;
    }

    return `${intro}Todavía necesito ${missingReadable.slice(0, -1).join(', ')} y ${missingReadable.at(-1)}.`;
  }
}
