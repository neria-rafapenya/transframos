import { Injectable, NotFoundException } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import type { LlmExtractionInterface } from '../../../common/interfaces/transport/llm-extraction.interface';
import type { QuoteContextInterface } from '../../../common/interfaces/transport/quote-context.interface';
import { LlmService } from '../../llm/llm.service';
import { PricingService } from '../../pricing/pricing.service';
import { QuoteOptionEntity } from '../../quote/entities/quote-option.entity';
import { QuoteService } from '../../quote/quote.service';
import { RulesService } from '../../rules/rules.service';
import { WizardService } from '../../wizard/wizard.service';
import { CatalogRepository } from '../../catalog/repositories/catalog.repository';
import { RouteSuggestionService } from '../../catalog/services/route-suggestion.service';
import { OrdersService } from '../../orders/orders.service';
import { UsersService } from '../../users/users.service';
import {
  buildDecorativeCoordinates,
} from '../../../common/utils/decorative-coordinates';

@Injectable()
export class ConversationOrchestratorService {
  constructor(
    private readonly llmService: LlmService,
    private readonly wizardService: WizardService,
    private readonly quoteService: QuoteService,
    private readonly rulesService: RulesService,
    private readonly pricingService: PricingService,
    private readonly catalogRepository: CatalogRepository,
    private readonly routeSuggestionService: RouteSuggestionService,
    private readonly ordersService: OrdersService,
    private readonly usersService: UsersService,
    private readonly configService: ConfigService,
  ) {}

  async processUserMessage(params: {
    sessionId: string;
    userId: string;
    userMessage: string;
    messageHistory: Array<{ role: string; content: string }>;
    forceTramitar?: boolean;
  }) {
    await this.wizardService.initializeSessionSteps(params.sessionId);

    const quoteRequest =
      await this.quoteService.findOrCreateByConversationSessionId(
        params.sessionId,
      );

    const user = await this.usersService.findById(params.userId);
    if (user.clientId && !quoteRequest.clientId) {
      await this.quoteService.updateQuoteRequestData(quoteRequest.id, {
        clientId: user.clientId,
      });
    }

    const orderNumber = this.extractOrderNumber(params.userMessage);
    const shouldRepeat =
      Boolean(orderNumber) &&
      (this.detectRepeatOrderIntent(params.userMessage) ||
        params.userMessage.trim().toUpperCase() === orderNumber);
    if (shouldRepeat && orderNumber) {
      return this.buildRepeatOrderResponse({
        sessionId: params.sessionId,
        userId: params.userId,
        user,
        orderNumber,
        quoteRequest,
      });
    }

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

    let missingFields = this.getMissingFieldsFromWizardStates(wizardStates);
    missingFields = this.appendPostalCodeMissing(
      missingFields,
      updatedQuoteRequest,
    );

    let validationSummary: Record<string, unknown> | null = null;
    let topOption: QuoteOptionEntity | null = null;
    let hasFailedValidations = false;

    if (missingFields.length === 0) {
      validationSummary = await this.rulesService.validateQuoteRequest(
        updatedQuoteRequest.id,
        {
          clearPreviousResults: true,
        },
      );

      hasFailedValidations = Array.isArray(validationSummary.results)
        ? validationSummary.results.some(
            (item: { validationStatus?: string }) =>
              item.validationStatus === 'failed',
          )
        : false;

      if (!hasFailedValidations) {
        topOption = await this.pricingService.calculateBestOption(
          updatedQuoteRequest.id,
        );
      }
    }

    let refreshedQuoteRequest =
      await this.quoteService.getQuoteRequestEntityById(updatedQuoteRequest.id);

    const wantsTramitar =
      params.forceTramitar || this.detectTramitarIntent(params.userMessage);

    if (
      wantsTramitar &&
      !hasFailedValidations &&
      missingFields.length === 0 &&
      !topOption
    ) {
      topOption = await this.pricingService.calculateBestOption(
        updatedQuoteRequest.id,
      );
    }

    const canFinalizeOrder =
      wantsTramitar && !hasFailedValidations && missingFields.length === 0;

    if (canFinalizeOrder) {
      const orderResult =
        await this.ordersService.createClosedOrderFromContext({
          quoteRequest: refreshedQuoteRequest,
          topOption,
          wizardStates,
          userId: params.userId,
        });

      const updatedQuoteRequest =
        await this.quoteService.getQuoteRequestEntityById(
          refreshedQuoteRequest.id,
        );

      const orderContext: QuoteContextInterface = {
        quoteRequest: updatedQuoteRequest,
        wizardStates,
        topOption,
        missingFields,
      };

      const routePreview = await this.buildRoutePreview(orderContext);

      const orderMessage = orderResult.created
        ? `Pedido tramitado correctamente. Número de pedido: ${orderResult.order.orderNumber}.`
        : `Este pedido ya estaba tramitado con número ${orderResult.order.orderNumber}.`;

      return {
        extraction,
        context: orderContext,
        validationSummary,
        assistantMessage: orderMessage,
        routePreview,
      };
    }

    const shouldEnterTramite = wantsTramitar && Boolean(topOption);

    if (shouldEnterTramite) {
      if (refreshedQuoteRequest.wizardStatus !== 'collecting_tramite') {
        await this.quoteService.updateQuoteRequestData(
          refreshedQuoteRequest.id,
          {
            wizardStatus: 'collecting_tramite',
          },
        );
        refreshedQuoteRequest =
          await this.quoteService.getQuoteRequestEntityById(
            refreshedQuoteRequest.id,
          );
      }
    }

    const isTramiteStage =
      refreshedQuoteRequest.wizardStatus === 'collecting_tramite';

    if (isTramiteStage) {
      missingFields = this.getMissingFieldsFromWizardStates(
        wizardStates,
        this.getTramiteRequiredStepCodes(),
      );
    }

    missingFields = this.appendPostalCodeMissing(
      missingFields,
      refreshedQuoteRequest,
    );

    const context: QuoteContextInterface = {
      quoteRequest: refreshedQuoteRequest,
      wizardStates,
      topOption,
      missingFields,
    };

    const assistantMessage = await this.buildAssistantMessage({
      userMessage: params.userMessage,
      extraction,
      context,
      validationSummary,
    });

    const routePreview = await this.buildRoutePreview(context);

    return {
      extraction,
      context,
      validationSummary,
      assistantMessage,
      routePreview,
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

    const now = new Date();
    const currentYear = now.getFullYear();
    const todayIso = now.toISOString().slice(0, 10);

    // TODO: Centralizar las instrucciones/algoritmos del LLM en una sola plantilla o archivo.
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
- originLat
- originLon
- destinationLat
- destinationLon
- originAddressText
- originContactName
- originContactPhone
- destinationAddressText
- destinationContactName
- destinationContactPhone
- requestedPickupAt
- deliveryDeadlineAt

Reglas:
- originText y destinationText deben contener ciudad y código postal si están disponibles.
- Si puedes inferir coordenadas aproximadas (latitud/longitud) para origen o destino usando ciudad o código postal, inclúyelas en originLat/originLon y destinationLat/destinationLon.
- Las coordenadas deben ser decimales y estar dentro de España (latitud 36.0-43.8, longitud -9.5 a 3.3). Si no estás seguro, usa null.
- Si un dato no aparece, usa null.
- requestedPickupAt y deliveryDeadlineAt deben ir en ISO 8601 si se pueden inferir con suficiente seguridad.
- Si el usuario indica una fecha sin año, asume el año vigente (${currentYear}). Fecha actual: ${todayIso}.
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
    "originLat": null,
    "originLon": null,
    "destinationLat": null,
    "destinationLon": null,
    "originAddressText": null,
    "originContactName": null,
    "originContactPhone": null,
    "destinationAddressText": null,
    "destinationContactName": null,
    "destinationContactPhone": null,
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

    const extraction = this.parseExtractionResponse(response.text);
    const normalized = this.normalizeExtractionDates(extraction, params.userMessage);
    const withCoords = this.applyCoordinateOverrides(normalized);
    return this.adjustExtractionForRepeatIntent(withCoords, params.userMessage);
  }

  private parseExtractionResponse(text: string): LlmExtractionInterface {
    try {
      const normalizeNumber = (value: unknown): number | null => {
        if (typeof value === 'number' && Number.isFinite(value)) {
          return value;
        }
        if (typeof value === 'string') {
          const parsed = Number(value.replace(',', '.'));
          return Number.isFinite(parsed) ? parsed : null;
        }
        return null;
      };

      const normalizeLat = (value: unknown): number | null => {
        const parsed = normalizeNumber(value);
        if (parsed === null) {
          return null;
        }
        if (parsed < 36.0 || parsed > 43.8) {
          return null;
        }
        return Number(parsed.toFixed(6));
      };

      const normalizeLon = (value: unknown): number | null => {
        const parsed = normalizeNumber(value);
        if (parsed === null) {
          return null;
        }
        if (parsed < -9.5 || parsed > 3.3) {
          return null;
        }
        return Number(parsed.toFixed(6));
      };

      const firstBrace = text.indexOf('{');
      const lastBrace = text.lastIndexOf('}');
      const cleaned = text.slice(firstBrace, lastBrace + 1);
      const parsed = JSON.parse(cleaned) as LlmExtractionInterface;
      const allowedMissingFields = new Set([
        'product',
        'quantity',
        'origin',
        'destination',
        'requested_date',
        'delivery_deadline',
      ]);

      return {
        intent: parsed.intent ?? 'create_or_update_quote_request',
        extractedFields: {
          productText: parsed.extractedFields?.productText ?? null,
          quantityValue: parsed.extractedFields?.quantityValue ?? null,
          quantityUnit: parsed.extractedFields?.quantityUnit ?? null,
          originText: parsed.extractedFields?.originText ?? null,
          destinationText: parsed.extractedFields?.destinationText ?? null,
          originLat: normalizeLat(parsed.extractedFields?.originLat),
          originLon: normalizeLon(parsed.extractedFields?.originLon),
          destinationLat: normalizeLat(parsed.extractedFields?.destinationLat),
          destinationLon: normalizeLon(parsed.extractedFields?.destinationLon),
          originAddressText: parsed.extractedFields?.originAddressText ?? null,
          originContactName: parsed.extractedFields?.originContactName ?? null,
          originContactPhone: parsed.extractedFields?.originContactPhone ?? null,
          destinationAddressText:
            parsed.extractedFields?.destinationAddressText ?? null,
          destinationContactName:
            parsed.extractedFields?.destinationContactName ?? null,
          destinationContactPhone:
            parsed.extractedFields?.destinationContactPhone ?? null,
          requestedPickupAt: parsed.extractedFields?.requestedPickupAt ?? null,
          deliveryDeadlineAt:
            parsed.extractedFields?.deliveryDeadlineAt ?? null,
        },
        missingFields: Array.isArray(parsed.missingFields)
          ? parsed.missingFields.filter((field) => allowedMissingFields.has(field))
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
          originLat: null,
          originLon: null,
          destinationLat: null,
          destinationLon: null,
          originAddressText: null,
          originContactName: null,
          originContactPhone: null,
          destinationAddressText: null,
          destinationContactName: null,
          destinationContactPhone: null,
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

  private normalizeExtractionDates(
    extraction: LlmExtractionInterface,
    userMessage: string,
  ): LlmExtractionInterface {
    const hasExplicitYear = /\b(19|20)\d{2}\b/.test(userMessage);
    if (hasExplicitYear) {
      return extraction;
    }

    const currentYear = new Date().getFullYear();
    const normalize = (
      value: string | null | undefined,
    ): string | null | undefined => {
      if (typeof value !== 'string') {
        return value;
      }

      const trimmed = value.trim();
      if (!trimmed) {
        return value;
      }

      const match = trimmed.match(/^(\d{4})([-/]\d{2}[-/]\d{2})(.*)$/);
      if (!match) {
        return value;
      }

      return `${currentYear}${match[2]}${match[3]}`;
    };

    return {
      ...extraction,
      extractedFields: {
        ...extraction.extractedFields,
        requestedPickupAt: normalize(extraction.extractedFields.requestedPickupAt),
        deliveryDeadlineAt: normalize(
          extraction.extractedFields.deliveryDeadlineAt,
        ),
      },
    };
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
      const originPayload: Record<string, unknown> = {
        originText: extraction.extractedFields.originText,
      };
      if (
        typeof extraction.extractedFields.originLat === 'number' &&
        typeof extraction.extractedFields.originLon === 'number'
      ) {
        originPayload.latitude = extraction.extractedFields.originLat;
        originPayload.longitude = extraction.extractedFields.originLon;
      }

      await this.wizardService.upsertSessionStepState(sessionId, 'origin', {
        status: 'completed',
        rawValueText: extraction.extractedFields.originText,
        valueJson: originPayload,
      });
    }

    if (extraction.extractedFields.destinationText) {
      const destinationPayload: Record<string, unknown> = {
        destinationText: extraction.extractedFields.destinationText,
      };
      if (
        typeof extraction.extractedFields.destinationLat === 'number' &&
        typeof extraction.extractedFields.destinationLon === 'number'
      ) {
        destinationPayload.latitude = extraction.extractedFields.destinationLat;
        destinationPayload.longitude =
          extraction.extractedFields.destinationLon;
      }

      await this.wizardService.upsertSessionStepState(
        sessionId,
        'destination',
        {
          status: 'completed',
          rawValueText: extraction.extractedFields.destinationText,
          valueJson: destinationPayload,
        },
      );
    }

    if (extraction.extractedFields.originAddressText) {
      const originAddressPayload: Record<string, unknown> = {
        originAddressText: extraction.extractedFields.originAddressText,
      };
      if (
        typeof extraction.extractedFields.originLat === 'number' &&
        typeof extraction.extractedFields.originLon === 'number'
      ) {
        originAddressPayload.latitude = extraction.extractedFields.originLat;
        originAddressPayload.longitude = extraction.extractedFields.originLon;
      }

      await this.wizardService.upsertSessionStepState(
        sessionId,
        'origin_address',
        {
          status: 'completed',
          rawValueText: extraction.extractedFields.originAddressText,
          valueJson: originAddressPayload,
        },
      );
    }

    if (extraction.extractedFields.originContactName) {
      await this.wizardService.upsertSessionStepState(
        sessionId,
        'origin_contact_name',
        {
          status: 'completed',
          rawValueText: extraction.extractedFields.originContactName,
          valueJson: {
            originContactName: extraction.extractedFields.originContactName,
          },
        },
      );
    }

    if (extraction.extractedFields.originContactPhone) {
      await this.wizardService.upsertSessionStepState(
        sessionId,
        'origin_contact_phone',
        {
          status: 'completed',
          rawValueText: extraction.extractedFields.originContactPhone,
          valueJson: {
            originContactPhone: extraction.extractedFields.originContactPhone,
          },
        },
      );
    }

    if (extraction.extractedFields.destinationAddressText) {
      const destinationAddressPayload: Record<string, unknown> = {
        destinationAddressText: extraction.extractedFields.destinationAddressText,
      };
      if (
        typeof extraction.extractedFields.destinationLat === 'number' &&
        typeof extraction.extractedFields.destinationLon === 'number'
      ) {
        destinationAddressPayload.latitude =
          extraction.extractedFields.destinationLat;
        destinationAddressPayload.longitude =
          extraction.extractedFields.destinationLon;
      }

      await this.wizardService.upsertSessionStepState(
        sessionId,
        'destination_address',
        {
          status: 'completed',
          rawValueText: extraction.extractedFields.destinationAddressText,
          valueJson: {
            ...destinationAddressPayload,
          },
        },
      );
    }

    if (extraction.extractedFields.destinationContactName) {
      await this.wizardService.upsertSessionStepState(
        sessionId,
        'destination_contact_name',
        {
          status: 'completed',
          rawValueText: extraction.extractedFields.destinationContactName,
          valueJson: {
            destinationContactName:
              extraction.extractedFields.destinationContactName,
          },
        },
      );
    }

    if (extraction.extractedFields.destinationContactPhone) {
      await this.wizardService.upsertSessionStepState(
        sessionId,
        'destination_contact_phone',
        {
          status: 'completed',
          rawValueText: extraction.extractedFields.destinationContactPhone,
          valueJson: {
            destinationContactPhone:
              extraction.extractedFields.destinationContactPhone,
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

  private getMissingFieldsFromWizardStates(
    wizardStates: Array<{
      status: string;
      wizardStep?: { code: string; isRequired: boolean };
    }>,
    forcedRequiredCodes: string[] = [],
  ): string[] {
    const forced = new Set(forcedRequiredCodes);
    return wizardStates
      .filter(
        (state) =>
          (state.wizardStep?.isRequired ||
            (state.wizardStep?.code
              ? forced.has(state.wizardStep.code)
              : false)) &&
          state.status !== 'completed' &&
          state.status !== 'skipped',
      )
      .map((state) => state.wizardStep?.code ?? 'unknown')
      .filter((code) => code !== 'unknown');
  }

  private async buildAssistantMessage(params: {
    userMessage: string;
    extraction: LlmExtractionInterface;
    context: QuoteContextInterface;
    validationSummary: Record<string, unknown> | null;
  }): Promise<string> {
    if (this.detectRepeatOrderIntent(params.userMessage)) {
      return this.buildRepeatOrderPrompt(params.userMessage);
    }

    if (this.detectHelpIntent(params.userMessage)) {
      return this.buildHelpMessage();
    }

    const earlyWarnings = await this.getEarlyWarnings(params.context);

    if (
      earlyWarnings.productMissing &&
      this.detectSalesIntent(params.userMessage)
    ) {
      await this.quoteService.updateQuoteRequestData(
        params.context.quoteRequest.id,
        {
          wizardStatus: 'sales_handoff',
        },
      );

      const salesEmail = this.getSalesContactEmail();
      return `Perfecto, para continuar ponte en contacto con ventas en ${salesEmail}.`;
    }

    if (params.context.missingFields.length > 0) {
      const isTramite =
        params.context.quoteRequest.wizardStatus === 'collecting_tramite';
      return this.buildMissingDataPrompt(
        params.extraction,
        params.context.missingFields,
        earlyWarnings.warnings,
        earlyWarnings.productMissing,
        isTramite ? 'tramite' : 'cotizacion',
        {
          noAvailability: earlyWarnings.noAvailability,
          suggestedDates: earlyWarnings.suggestedDates,
          routeLabel: earlyWarnings.routeLabel,
          usedProductFilter: earlyWarnings.usedProductFilter,
        },
      );
    }

    const failed = Array.isArray(params.validationSummary?.results)
      ? params.validationSummary.results.some(
          (item: { validationStatus?: string }) =>
            item.validationStatus === 'failed',
        )
      : false;

    if (failed) {
      if (earlyWarnings.noAvailability) {
        return this.buildMissingDataPrompt(
          params.extraction,
          [],
          earlyWarnings.warnings,
          earlyWarnings.productMissing,
          'cotizacion',
          {
            noAvailability: earlyWarnings.noAvailability,
            suggestedDates: earlyWarnings.suggestedDates,
            routeLabel: earlyWarnings.routeLabel,
            usedProductFilter: earlyWarnings.usedProductFilter,
          },
        );
      }

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

      const summary = await this.buildOrderSummary(params.context);
      const costText =
        typeof option.estimatedCost === 'number'
          ? `${option.estimatedCost}`
          : 'pendiente';
      const transitText =
        typeof option.estimatedTransitHours === 'number'
          ? `${option.estimatedTransitHours}`
          : null;

      const transitLine = transitText
        ? ` Tránsito estimado: ${transitText} horas.`
        : '';

      return `Resumen: ${summary} Coste estimado: ${costText} €.${transitLine}`;
    }

    const summary = await this.buildOrderSummary(params.context);
    return `Resumen: ${summary}`;
  }

  private buildMissingDataPrompt(
    extraction: LlmExtractionInterface,
    missingFields: string[],
    warnings: string[] = [],
    productMissing = false,
    mode: 'cotizacion' | 'tramite' = 'cotizacion',
    availabilityContext?: {
      noAvailability: boolean;
      suggestedDates: string[];
      routeLabel: string | null;
      usedProductFilter: boolean;
    },
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

    if (extraction.extractedFields.originAddressText) {
      understood.push(
        `dirección de recogida: ${extraction.extractedFields.originAddressText}`,
      );
    }

    if (extraction.extractedFields.originContactName) {
      understood.push(
        `responsable de recogida: ${extraction.extractedFields.originContactName}`,
      );
    }

    if (extraction.extractedFields.originContactPhone) {
      understood.push(
        `teléfono de recogida: ${extraction.extractedFields.originContactPhone}`,
      );
    }

    if (extraction.extractedFields.destinationAddressText) {
      understood.push(
        `dirección de entrega: ${extraction.extractedFields.destinationAddressText}`,
      );
    }

    if (extraction.extractedFields.destinationContactName) {
      understood.push(
        `responsable de entrega: ${extraction.extractedFields.destinationContactName}`,
      );
    }

    if (extraction.extractedFields.destinationContactPhone) {
      understood.push(
        `teléfono de entrega: ${extraction.extractedFields.destinationContactPhone}`,
      );
    }

    if (extraction.extractedFields.requestedPickupAt) {
      const formatted = this.formatDateForDisplay(
        extraction.extractedFields.requestedPickupAt,
      );
      understood.push(
        `fecha de recogida: ${
          formatted ?? extraction.extractedFields.requestedPickupAt
        }`,
      );
    }

    if (extraction.extractedFields.deliveryDeadlineAt) {
      const formatted = this.formatDateForDisplay(
        extraction.extractedFields.deliveryDeadlineAt,
      );
      understood.push(
        `límite de entrega: ${
          formatted ?? extraction.extractedFields.deliveryDeadlineAt
        }`,
      );
    }

    const labels: Record<string, string> = {
      product: 'el producto',
      quantity: 'la cantidad',
      origin: 'la ciudad y el código postal de origen',
      destination: 'la ciudad y el código postal de destino',
      origin_postal_code: 'el código postal de origen',
      destination_postal_code: 'el código postal de destino',
      origin_address: 'la dirección exacta de recogida',
      origin_contact_name: 'el responsable de recogida',
      origin_contact_phone: 'el teléfono de recogida',
      destination_address: 'la dirección exacta de entrega',
      destination_contact_name: 'el responsable de entrega',
      destination_contact_phone: 'el teléfono de entrega',
      requested_date: 'la fecha de recogida',
      delivery_deadline: 'el límite de entrega',
    };

    const missingReadable = missingFields.map(
      (field) => labels[field] ?? field,
    );

    const intro =
      understood.length > 0 ? `He entendido ${understood.join(', ')}. ` : '';
    const warningText = warnings.length > 0 ? `${warnings.join(' ')} ` : '';

    if (availabilityContext?.noAvailability) {
      const dates = availabilityContext.suggestedDates;
      const routeText = availabilityContext.routeLabel
        ? ` para la ruta ${availabilityContext.routeLabel}`
        : '';
      const productText = availabilityContext.usedProductFilter
        ? ' y el producto indicado'
        : '';
      const formattedDates =
        dates.length > 0
          ? dates
              .map((date) => this.formatDateForDisplay(date) ?? date)
              .join(', ')
          : '';
      const datesText =
        dates.length > 0
          ? ` Fechas disponibles${routeText}${productText}: ${formattedDates}.`
          : ` No tengo fechas alternativas${routeText}${productText} registradas todavía.`;

      return `${warningText}${intro}¿Quieres cambiar la fecha de recogida?${datesText}`;
    }

    if (mode === 'tramite') {
      if (missingReadable.length === 1) {
        return `${warningText}Para tramitar la opción necesito ${missingReadable[0]}.`;
      }

      if (missingReadable.length === 2) {
        return `${warningText}Para tramitar la opción necesito ${missingReadable[0]} y ${missingReadable[1]}. ¿Me los indicas?`;
      }

      return `${warningText}Para tramitar la opción necesito ${missingReadable.slice(0, -1).join(', ')} y ${missingReadable.at(-1)}.`;
    }

    if (productMissing) {
      return `${warningText}${intro}Antes de seguir, necesito que indiques un producto que esté en el catálogo. ¿Puedes decirme otro producto? Si prefieres, puedo pasar tu solicitud a ventas.`;
    }

    if (missingReadable.length === 1) {
      return `${warningText}${intro}Me falta ${missingReadable[0]}.`;
    }

    if (missingReadable.length === 2) {
      return `${warningText}${intro}Me faltan ${missingReadable[0]} y ${missingReadable[1]}. ¿Me los indicas?`;
    }

    return `${warningText}${intro}Todavía necesito ${missingReadable.slice(0, -1).join(', ')} y ${missingReadable.at(-1)}.`;
  }

  private async getEarlyWarnings(
    context: QuoteContextInterface,
  ): Promise<{
    warnings: string[];
    productMissing: boolean;
    noAvailability: boolean;
    suggestedDates: string[];
    routeLabel: string | null;
    usedProductFilter: boolean;
  }> {
    const warnings: string[] = [];
    let productMissing = false;
    let noAvailability = false;
    let suggestedDates: string[] = [];
    let routeLabel: string | null = null;
    let usedProductFilter = false;
    const productText = context.quoteRequest.requestedProductText;

    if (productText && productText !== 'Pendiente') {
      const product = await this.catalogRepository.findProductByText(productText);
      if (!product) {
        warnings.push(
          'Aviso: el producto indicado no está en el catálogo.',
        );
        productMissing = true;
      }
    }

    if (context.quoteRequest.requestedLoadDate) {
      const vehicles = await this.catalogRepository.findVehicles(true);
      if (vehicles.length === 0) {
        warnings.push('Aviso: no hay vehículos activos en la flota.');
      } else {
        const availability =
          await this.catalogRepository.findVehicleAvailabilityByDate(
            context.quoteRequest.requestedLoadDate,
          );
        if (availability.length === 0) {
          warnings.push(
            'Aviso: no hay disponibilidad registrada para esa fecha.',
          );
          noAvailability = true;
          const suggestion = await this.getAvailabilitySuggestions(context);
          suggestedDates = suggestion.dates;
          routeLabel = suggestion.routeLabel;
          usedProductFilter = suggestion.usedProductFilter;
        }
      }
    }

    return {
      warnings,
      productMissing,
      noAvailability,
      suggestedDates,
      routeLabel,
      usedProductFilter,
    };
  }

  private async getAvailabilitySuggestions(
    context: QuoteContextInterface,
  ): Promise<{
    dates: string[];
    routeLabel: string | null;
    usedProductFilter: boolean;
  }> {
    const requestedDate = context.quoteRequest.requestedLoadDate;
    if (!requestedDate) {
      return { dates: [], routeLabel: null, usedProductFilter: false };
    }

    let route = context.quoteRequest.suggestedRouteId
      ? await this.catalogRepository.findRouteById(
          context.quoteRequest.suggestedRouteId,
        )
      : null;

    if (
      !route &&
      context.quoteRequest.originLoadingPointId &&
      context.quoteRequest.destinationUnloadingPointId
    ) {
      route = await this.catalogRepository.findRouteByPoints(
        context.quoteRequest.originLoadingPointId,
        context.quoteRequest.destinationUnloadingPointId,
      );
    }

    if (
      !route &&
      context.quoteRequest.originText &&
      context.quoteRequest.destinationText
    ) {
      const originPoint = await this.catalogRepository.findLoadingPointByText(
        context.quoteRequest.originText,
      );
      const destinationPoint =
        await this.catalogRepository.findUnloadingPointByText(
          context.quoteRequest.destinationText,
        );
      if (originPoint && destinationPoint) {
        route = await this.catalogRepository.findRouteByPoints(
          originPoint.id,
          destinationPoint.id,
        );
      }
    }

    if (
      !route &&
      context.quoteRequest.originText &&
      context.quoteRequest.destinationText
    ) {
      const suggestion = await this.routeSuggestionService.suggestRoute({
        originText: context.quoteRequest.originText,
        destinationText: context.quoteRequest.destinationText,
        userId: null,
      });
      route = suggestion.route;
    }

    const routeLabel = route ? route.code ?? route.name ?? null : null;

    let routeVehicleIds = new Set<string>();
    if (route) {
      const routeLinks = await this.catalogRepository.findVehicleRouteLinks({
        routeId: route.id,
      });
      routeVehicleIds = new Set(routeLinks.map((link) => link.vehicleId));
    }

    let productId = context.quoteRequest.requestedProductId ?? null;
    let categoryId = context.quoteRequest.requestedCategoryId ?? null;

    if ((!productId || !categoryId) && context.quoteRequest.requestedProductText) {
      const productEntity = await this.catalogRepository.findProductByText(
        context.quoteRequest.requestedProductText,
      );
      if (!productId) {
        productId = productEntity?.id ?? null;
      }
      if (!categoryId) {
        categoryId = productEntity?.categoryId ?? null;
      }
    }

    let productVehicleIds = new Set<string>();
    let usedProductFilter = false;

    if (productId || categoryId) {
      const tanks = await this.catalogRepository.findAuthorizedTanks({
        productId,
        categoryId,
        date: requestedDate,
      });
      if (tanks.length > 0) {
        const vehicleTanks = await this.catalogRepository.findVehicleTankLinks({
          tankIds: tanks.map((tank) => tank.id),
          date: requestedDate,
        });
        productVehicleIds = new Set(vehicleTanks.map((link) => link.vehicleId));
        if (productVehicleIds.size > 0) {
          usedProductFilter = true;
        }
      }
    }

    let candidateVehicleIds: string[] = [];
    if (routeVehicleIds.size > 0 && productVehicleIds.size > 0) {
      candidateVehicleIds = Array.from(routeVehicleIds).filter((id) =>
        productVehicleIds.has(id),
      );
      if (candidateVehicleIds.length > 0) {
        usedProductFilter = true;
      }
    } else if (routeVehicleIds.size > 0) {
      candidateVehicleIds = Array.from(routeVehicleIds);
    } else if (productVehicleIds.size > 0) {
      candidateVehicleIds = Array.from(productVehicleIds);
      usedProductFilter = true;
    }

    const availability =
      candidateVehicleIds.length > 0
        ? await this.catalogRepository.findVehicleAvailabilityByVehicleIds(
            candidateVehicleIds,
          )
        : await this.catalogRepository.findAllVehicleAvailability();

    const uniqueDates = Array.from(
      new Set(
        availability
          .filter((item) => item.available)
          .map((item) => item.availabilityDate)
          .filter((date) => date !== requestedDate),
      ),
    );

    return {
      dates: uniqueDates.slice(0, 5),
      routeLabel,
      usedProductFilter,
    };
  }

  private async buildRoutePreview(
    context: QuoteContextInterface,
  ): Promise<{
    origin: { lat: number; lon: number; label: string | null; isApproximate: boolean } | null;
    destination: { lat: number; lon: number; label: string | null; isApproximate: boolean } | null;
    isApproximate: boolean;
  } | null> {
    const normalizeCoord = (value: unknown): number | null => {
      if (typeof value === 'number' && Number.isFinite(value)) {
        return value;
      }
      if (typeof value === 'string') {
        const parsed = Number(value);
        return Number.isFinite(parsed) ? parsed : null;
      }
      return null;
    };

    const withinSpain = (lat: number, lon: number) =>
      lat >= 36.0 && lat <= 43.8 && lon >= -9.5 && lon <= 3.3;

    const parseWizardJson = (value: unknown): Record<string, unknown> | null => {
      if (!value) {
        return null;
      }
      if (typeof value === 'string') {
        try {
          return JSON.parse(value) as Record<string, unknown>;
        } catch {
          return null;
        }
      }
      if (typeof value === 'object') {
        return value as Record<string, unknown>;
      }
      return null;
    };

    const getWizardCoords = (codes: string[]) => {
      for (const code of codes) {
        const state = context.wizardStates.find(
          (item) => item.wizardStep?.code === code,
        );
        const payload = parseWizardJson(state?.normalizedValueJson);
        if (!payload) {
          continue;
        }

        const lat = normalizeCoord(
          payload.latitude ?? payload.lat ?? payload.originLat ?? payload.destinationLat,
        );
        const lon = normalizeCoord(
          payload.longitude ?? payload.lon ?? payload.originLon ?? payload.destinationLon,
        );

        if (lat !== null && lon !== null && withinSpain(lat, lon)) {
          return { lat, lon };
        }
      }

      return null;
    };

    let originApprox = false;
    let destinationApprox = false;

    let originPoint = context.quoteRequest.originLoadingPointId
      ? await this.catalogRepository.findLoadingPointById(
          context.quoteRequest.originLoadingPointId,
        )
      : null;
    const originLat = normalizeCoord(originPoint?.latitude ?? null);
    const originLon = normalizeCoord(originPoint?.longitude ?? null);

    let originCoords =
      originLat !== null && originLon !== null
        ? { lat: originLat, lon: originLon }
        : null;

    if (!originCoords) {
      const originLookupText =
        this.getWizardValue(context, 'origin_address') ??
        this.getWizardValue(context, 'origin') ??
        context.quoteRequest.originText ??
        '';
      if (originLookupText) {
        const found = await this.catalogRepository.findLoadingPointByText(
          originLookupText,
        );
        const foundLat = normalizeCoord(found?.latitude ?? null);
        const foundLon = normalizeCoord(found?.longitude ?? null);
        if (foundLat !== null && foundLon !== null) {
          originPoint = found;
          originCoords = { lat: foundLat, lon: foundLon };
        }
      }
    }

    if (!originCoords) {
      const wizardCoords = getWizardCoords(['origin_address', 'origin']);
      if (wizardCoords) {
        originCoords = wizardCoords;
        originApprox = true;
      }
    }

    if (originCoords) {
      const originSeed =
        this.getWizardValue(context, 'origin_address') ??
        this.getWizardValue(context, 'origin') ??
        context.quoteRequest.originText ??
        '';
      const originOverride = this.getCityCoordinateOverride(originSeed);
      if (
        originOverride &&
        this.shouldOverrideCoords(originOverride, originCoords.lat, originCoords.lon)
      ) {
        originCoords = originOverride;
        originApprox = true;
      }
    }

    if (!originCoords) {
      const originSeed =
        this.getWizardValue(context, 'origin_address') ??
        this.getWizardValue(context, 'origin') ??
        context.quoteRequest.originText ??
        '';
      const coords = buildDecorativeCoordinates(originSeed);
      if (coords) {
        originCoords = { lat: coords.latitude, lon: coords.longitude };
        originApprox = true;
      }
    }

    let destinationPoint = context.quoteRequest.destinationUnloadingPointId
      ? await this.catalogRepository.findUnloadingPointById(
          context.quoteRequest.destinationUnloadingPointId,
        )
      : null;
    const destinationLat = normalizeCoord(destinationPoint?.latitude ?? null);
    const destinationLon = normalizeCoord(destinationPoint?.longitude ?? null);

    let destinationCoords =
      destinationLat !== null && destinationLon !== null
        ? { lat: destinationLat, lon: destinationLon }
        : null;

    if (!destinationCoords) {
      const destinationLookupText =
        this.getWizardValue(context, 'destination_address') ??
        this.getWizardValue(context, 'destination') ??
        context.quoteRequest.destinationText ??
        '';
      if (destinationLookupText) {
        const found = await this.catalogRepository.findUnloadingPointByText(
          destinationLookupText,
        );
        const foundLat = normalizeCoord(found?.latitude ?? null);
        const foundLon = normalizeCoord(found?.longitude ?? null);
        if (foundLat !== null && foundLon !== null) {
          destinationPoint = found;
          destinationCoords = { lat: foundLat, lon: foundLon };
        }
      }
    }

    if (!destinationCoords) {
      const wizardCoords = getWizardCoords(['destination_address', 'destination']);
      if (wizardCoords) {
        destinationCoords = wizardCoords;
        destinationApprox = true;
      }
    }

    if (destinationCoords) {
      const destinationSeed =
        this.getWizardValue(context, 'destination_address') ??
        this.getWizardValue(context, 'destination') ??
        context.quoteRequest.destinationText ??
        '';
      const destinationOverride = this.getCityCoordinateOverride(destinationSeed);
      if (
        destinationOverride &&
        this.shouldOverrideCoords(
          destinationOverride,
          destinationCoords.lat,
          destinationCoords.lon,
        )
      ) {
        destinationCoords = destinationOverride;
        destinationApprox = true;
      }
    }

    if (!destinationCoords) {
      const destinationSeed =
        this.getWizardValue(context, 'destination_address') ??
        this.getWizardValue(context, 'destination') ??
        context.quoteRequest.destinationText ??
        '';
      const coords = buildDecorativeCoordinates(destinationSeed);
      if (coords) {
        destinationCoords = { lat: coords.latitude, lon: coords.longitude };
        destinationApprox = true;
      }
    }

    if (!originCoords && !destinationCoords) {
      return null;
    }

    return {
      origin: originCoords
        ? {
            lat: originCoords.lat,
            lon: originCoords.lon,
            label:
              originPoint?.city ??
              this.getWizardValue(context, 'origin') ??
              context.quoteRequest.originText ??
              null,
            isApproximate: originApprox,
          }
        : null,
      destination: destinationCoords
        ? {
            lat: destinationCoords.lat,
            lon: destinationCoords.lon,
            label:
              destinationPoint?.city ??
              this.getWizardValue(context, 'destination') ??
              context.quoteRequest.destinationText ??
              null,
            isApproximate: destinationApprox,
          }
        : null,
      isApproximate: originApprox || destinationApprox,
    };
  }

  private detectSalesIntent(message: string): boolean {
    const normalized = message.toLowerCase();
    return (
      normalized.includes('ventas') ||
      normalized.includes('comercial') ||
      normalized.includes('contactar') ||
      normalized.includes('contacto') ||
      normalized.includes('llamar') ||
      normalized.includes('pasa la solicitud')
    );
  }

  private detectTramitarIntent(message: string): boolean {
    const normalized = message.toLowerCase();
    return (
      normalized.includes('tramitar') ||
      normalized.includes('tramita') ||
      normalized.includes('confirmo') ||
      normalized.includes('confirmar') ||
      normalized.includes('acepto') ||
      normalized.includes('aceptar') ||
      normalized.includes('proceder') ||
      normalized.includes('seguir adelante') ||
      normalized.includes('continuar') ||
      normalized.includes('quiero contratar') ||
      normalized.includes('haz el pedido') ||
      normalized.includes('resérvalo')
    );
  }

  private detectRepeatOrderIntent(message: string): boolean {
    const normalized = message.toLowerCase();
    const normalizedPlain = normalized
      .normalize('NFD')
      .replace(/\p{Diacritic}/gu, '');
    return (
      normalized.includes('repetir') ||
      normalized.includes('repite') ||
      normalized.includes('repetir pedido') ||
      normalized.includes('repetir el pedido') ||
      normalized.includes('volver a pedir') ||
      normalized.includes('mismo pedido') ||
      normalized.includes('duplicar') ||
      normalized.includes('hacer el mismo pedido') ||
      normalized.includes('repitir') ||
      normalized.includes('reptir') ||
      /rep(e|i)?tir/.test(normalizedPlain)
    );
  }

  private detectHelpIntent(message: string): boolean {
    const normalized = message.toLowerCase();
    const normalizedPlain = normalized
      .normalize('NFD')
      .replace(/\p{Diacritic}/gu, '');
    const hasQueSabes =
      normalizedPlain.includes('que sabes') ||
      normalizedPlain.includes('que sabes hacer') ||
      normalizedPlain.includes('que puedes') ||
      normalizedPlain.includes('que puedes hacer') ||
      normalizedPlain.includes('que haces');

    const hasHelpKeyword =
      normalizedPlain.includes('como funciona') ||
      normalizedPlain.includes('como puedo') ||
      normalizedPlain.includes('ayuda') ||
      normalizedPlain.includes('necesito ayuda');

    const hasGreeting =
      normalizedPlain.includes('hola') ||
      normalizedPlain.includes('buenas') ||
      normalizedPlain.includes('buenos dias') ||
      normalizedPlain.includes('buenas tardes') ||
      normalizedPlain.includes('buenas noches');

    const hasTePregunto =
      normalizedPlain.includes('te pregunto') && hasQueSabes;

    return hasQueSabes || hasHelpKeyword || hasGreeting || hasTePregunto;
  }

  private isExtractionEmpty(extraction: LlmExtractionInterface): boolean {
    const fields = extraction.extractedFields;
    return (
      !fields.productText &&
      fields.quantityValue === null &&
      !fields.originText &&
      !fields.destinationText &&
      !fields.requestedPickupAt &&
      !fields.deliveryDeadlineAt
    );
  }

  private buildHelpMessage(): string {
    return (
      'Puedo ayudarte a tramitar transportes de líquidos. ' +
      'Para empezar, indícame el producto, la cantidad, la ciudad y el código postal de origen, ' +
      'la ciudad y el código postal de destino, y las fechas de recogida y entrega. ' +
      'Ejemplo: "Necesito transportar 12000 litros de leche desde 25005 Lleida hasta 46024 Valencia, ' +
      'recogida el 12/05/2026 y entrega antes del 14/05/2026". ' +
      'Si quieres continuar con el pedido actual, dime "continuar" o añade los datos que falten.'
    );
  }

  private buildRepeatOrderPrompt(message: string): string {
    const orderNumber = this.extractOrderNumber(message);
    if (orderNumber) {
      return `Perfecto, voy a repetir el pedido ${orderNumber}. ¿Quieres mantener las mismas fechas de transporte o deseas cambiarlas?`;
    }
    return 'Para repetir un pedido necesito el número de pedido (formato ORD-YYYYMMDD-XXXX) o confirmar que la fecha indicada corresponde a la creación del pedido. ¿Me lo puedes indicar?';
  }

  private buildEmptyExtraction(intent = 'repeat_order'): LlmExtractionInterface {
    return {
      intent,
      extractedFields: {
        productText: null,
        quantityValue: null,
        quantityUnit: null,
        originText: null,
        destinationText: null,
        originLat: null,
        originLon: null,
        destinationLat: null,
        destinationLon: null,
        originAddressText: null,
        originContactName: null,
        originContactPhone: null,
        destinationAddressText: null,
        destinationContactName: null,
        destinationContactPhone: null,
        requestedPickupAt: null,
        deliveryDeadlineAt: null,
      },
      missingFields: [],
      nextBestQuestion: null,
      confidence: null,
    };
  }

  private buildLocationLabel(point: {
    city?: string | null;
    postalCode?: string | null;
    name?: string | null;
  } | null): string | null {
    if (!point) {
      return null;
    }
    const parts = [point.city?.trim(), point.postalCode?.trim()].filter(Boolean);
    if (parts.length > 0) {
      return parts.join(' ');
    }
    return point.name?.trim() ?? null;
  }

  private async upsertWizardValue(
    sessionId: string,
    stepCode: string,
    rawValueText: string | null,
    valueJson?: Record<string, unknown> | null,
  ) {
    if (!rawValueText) {
      return;
    }

    await this.wizardService.upsertSessionStepState(sessionId, stepCode, {
      status: 'completed',
      rawValueText,
      valueJson: valueJson ?? undefined,
    });
  }

  private async buildRepeatOrderResponse(params: {
    sessionId: string;
    userId: string;
    user: {
      fullName: string;
      email: string;
      contactName?: string | null;
      contactPhone?: string | null;
    };
    orderNumber: string;
    quoteRequest: { id: string };
  }) {
    let order;
    try {
      order = await this.ordersService.getOrderByNumberForUser(
        params.userId,
        params.orderNumber,
      );
    } catch {
      const wizardStates = await this.wizardService.getSessionStepStates(
        params.sessionId,
      );
      const missingFields = this.getMissingFieldsFromWizardStates(wizardStates);
      const context: QuoteContextInterface = {
        quoteRequest: await this.quoteService.getQuoteRequestEntityById(
          params.quoteRequest.id,
        ),
        wizardStates,
        topOption: null,
        missingFields,
      };
      const routePreview = await this.buildRoutePreview(context);
      return {
        extraction: this.buildEmptyExtraction('repeat_order'),
        context,
        validationSummary: null,
        assistantMessage: `No encuentro el pedido ${params.orderNumber}. ¿Puedes comprobar el número o indicar la fecha de creación exacta?`,
        routePreview,
      };
    }

    const [product, originPoint, destinationPoint] = await Promise.all([
      this.catalogRepository.findProductById(order.productId),
      this.catalogRepository.findLoadingPointById(order.originLoadingPointId),
      this.catalogRepository.findUnloadingPointById(
        order.destinationUnloadingPointId,
      ),
    ]);

    const productLabel =
      product?.commercialName ?? product?.name ?? product?.code ?? 'Producto';
    const originText = this.buildLocationLabel(originPoint);
    const destinationText = this.buildLocationLabel(destinationPoint);

    const pickupAt = order.requestedPickupDatetime ?? null;
    const deliveryAt = order.requestedDeliveryDatetime ?? null;
    const quantityValue = order.orderedVolumeLiters ?? null;
    const quantityUnit = 'litros';

    await this.quoteService.updateQuoteRequestData(params.quoteRequest.id, {
      productText: productLabel,
      productId: order.productId,
      categoryId: order.categoryId,
      quantityValue,
      quantityUnit,
      originLocationId: order.originLoadingPointId,
      destinationLocationId: order.destinationUnloadingPointId,
      originText,
      destinationText,
      requestedPickupAt: pickupAt,
      deliveryDeadlineAt: deliveryAt,
      validationStatus: 'pending',
      wizardStatus: 'idle',
    });

    await this.upsertWizardValue(params.sessionId, 'product', productLabel, {
      productText: productLabel,
    });

    if (quantityValue !== null) {
      await this.upsertWizardValue(
        params.sessionId,
        'quantity',
        `${quantityValue} ${quantityUnit}`,
        {
          quantityValue,
          quantityUnit,
        },
      );
    }

    if (originText) {
      await this.upsertWizardValue(params.sessionId, 'origin', originText, {
        originText,
        originLat: originPoint?.latitude ?? null,
        originLon: originPoint?.longitude ?? null,
      });
    }

    if (destinationText) {
      await this.upsertWizardValue(
        params.sessionId,
        'destination',
        destinationText,
        {
          destinationText,
          destinationLat: destinationPoint?.latitude ?? null,
          destinationLon: destinationPoint?.longitude ?? null,
        },
      );
    }

    await this.upsertWizardValue(
      params.sessionId,
      'origin_address',
      originPoint?.addressLine1 ?? null,
    );
    await this.upsertWizardValue(
      params.sessionId,
      'destination_address',
      destinationPoint?.addressLine1 ?? null,
    );

    const contactName = params.user.contactName ?? params.user.fullName;
    const contactPhone = params.user.contactPhone ?? null;
    if (contactName) {
      await this.upsertWizardValue(
        params.sessionId,
        'origin_contact_name',
        contactName,
      );
      await this.upsertWizardValue(
        params.sessionId,
        'destination_contact_name',
        contactName,
      );
    }

    if (contactPhone) {
      await this.upsertWizardValue(
        params.sessionId,
        'origin_contact_phone',
        contactPhone,
      );
      await this.upsertWizardValue(
        params.sessionId,
        'destination_contact_phone',
        contactPhone,
      );
    }

    if (pickupAt) {
      await this.upsertWizardValue(
        params.sessionId,
        'requested_date',
        pickupAt.toISOString(),
        { requestedPickupAt: pickupAt.toISOString() },
      );
    }

    if (deliveryAt) {
      await this.upsertWizardValue(
        params.sessionId,
        'delivery_deadline',
        deliveryAt.toISOString(),
        { deliveryDeadlineAt: deliveryAt.toISOString() },
      );
    }

    const refreshedQuoteRequest =
      await this.quoteService.getQuoteRequestEntityById(
        params.quoteRequest.id,
      );
    const wizardStates = await this.wizardService.getSessionStepStates(
      params.sessionId,
    );

    let missingFields = this.getMissingFieldsFromWizardStates(wizardStates);
    missingFields = this.appendPostalCodeMissing(
      missingFields,
      refreshedQuoteRequest,
    );

    let validationSummary: Record<string, unknown> | null = null;
    let topOption: QuoteOptionEntity | null = null;
    let hasFailedValidations = false;

    if (missingFields.length === 0) {
      validationSummary = await this.rulesService.validateQuoteRequest(
        refreshedQuoteRequest.id,
        {
          clearPreviousResults: true,
        },
      );

      hasFailedValidations = Array.isArray(validationSummary.results)
        ? validationSummary.results.some(
            (item: { validationStatus?: string }) =>
              item.validationStatus === 'failed',
          )
        : false;

      if (!hasFailedValidations) {
        topOption = await this.pricingService.calculateBestOption(
          refreshedQuoteRequest.id,
        );
      }
    }

    const context: QuoteContextInterface = {
      quoteRequest: refreshedQuoteRequest,
      wizardStates,
      topOption,
      missingFields,
    };

    const routePreview = await this.buildRoutePreview(context);
    const assistantMessage =
      `He cargado los datos del pedido ${params.orderNumber}. ` +
      (missingFields.length === 0
        ? 'Si quieres repetirlo tal cual, escribe "tramitar". Si quieres cambiar algo, dímelo.'
        : 'Si quieres cambiar algún dato antes de tramitar, indícalo. También puedes completar los datos que falten.');

    return {
      extraction: this.buildEmptyExtraction('repeat_order'),
      context,
      validationSummary,
      assistantMessage,
      routePreview,
    };
  }

  private extractOrderNumber(message: string): string | null {
    const match = message.toUpperCase().match(/ORD-\d{8}-[A-Z0-9]{4}/);
    return match ? match[0] : null;
  }

  private getTramiteRequiredStepCodes(): string[] {
    return [
      'origin_address',
      'destination_address',
      'origin_contact_name',
      'origin_contact_phone',
      'destination_contact_name',
      'destination_contact_phone',
    ];
  }

  private getSalesContactEmail(): string {
    const configured = this.configService.get<string>('SALES_CONTACT_EMAIL');
    return configured && configured.trim().length > 0
      ? configured.trim()
      : 'ventas@transframos.com';
  }

  private getWizardValue(
    context: QuoteContextInterface,
    stepCode: string,
  ): string | null {
    const state = context.wizardStates.find(
      (item) => item.wizardStep?.code === stepCode,
    );

    return state?.rawValueText ?? null;
  }

  private applyCoordinateOverrides(
    extraction: LlmExtractionInterface,
  ): LlmExtractionInterface {
    const originText =
      extraction.extractedFields.originAddressText ??
      extraction.extractedFields.originText ??
      null;
    const destinationText =
      extraction.extractedFields.destinationAddressText ??
      extraction.extractedFields.destinationText ??
      null;

    const originOverride = this.getCityCoordinateOverride(originText);
    const destinationOverride = this.getCityCoordinateOverride(destinationText);

    const nextFields = { ...extraction.extractedFields };

    if (
      originOverride &&
      this.shouldOverrideCoords(
        originOverride,
        nextFields.originLat ?? null,
        nextFields.originLon ?? null,
      )
    ) {
      nextFields.originLat = originOverride.lat;
      nextFields.originLon = originOverride.lon;
    }

    if (
      destinationOverride &&
      this.shouldOverrideCoords(
        destinationOverride,
        nextFields.destinationLat ?? null,
        nextFields.destinationLon ?? null,
      )
    ) {
      nextFields.destinationLat = destinationOverride.lat;
      nextFields.destinationLon = destinationOverride.lon;
    }

    return {
      ...extraction,
      extractedFields: nextFields,
    };
  }

  private adjustExtractionForRepeatIntent(
    extraction: LlmExtractionInterface,
    userMessage: string,
  ): LlmExtractionInterface {
    if (!this.detectRepeatOrderIntent(userMessage)) {
      return extraction;
    }

    return {
      ...extraction,
      extractedFields: {
        ...extraction.extractedFields,
        requestedPickupAt: null,
        deliveryDeadlineAt: null,
      },
    };
  }

  private shouldOverrideCoords(
    target: { lat: number; lon: number },
    lat: number | null,
    lon: number | null,
  ): boolean {
    if (typeof lat !== 'number' || typeof lon !== 'number') {
      return true;
    }
    const delta = Math.hypot(lat - target.lat, lon - target.lon);
    return delta > 0.35;
  }

  private getCityCoordinateOverride(
    placeText: string | null | undefined,
  ): { lat: number; lon: number } | null {
    if (!placeText) {
      return null;
    }

    const normalized = this.normalizePlaceText(placeText);
    if (!normalized) {
      return null;
    }

    const tokens: string[] = normalized.match(/[a-z0-9]+/g) ?? [];
    const postalPrefixes = this.extractPostalPrefixes(normalized);

    const overrides: Array<{
      token: string;
      lat: number;
      lon: number;
      postalPrefixes: string[];
    }> = [
      { token: 'valencia', lat: 39.4699, lon: -0.3763, postalPrefixes: ['46'] },
      { token: 'lleida', lat: 41.6176, lon: 0.6200, postalPrefixes: ['25'] },
    ];

    for (const override of overrides) {
      if (tokens.includes(override.token)) {
        return { lat: override.lat, lon: override.lon };
      }
      if (
        postalPrefixes.some((prefix) =>
          override.postalPrefixes.includes(prefix),
        )
      ) {
        return { lat: override.lat, lon: override.lon };
      }
    }

    return null;
  }

  private extractPostalPrefixes(normalized: string): string[] {
    const matches = normalized.match(/\b\d{5}\b/g) ?? [];
    return matches.map((code) => code.slice(0, 2));
  }

  private normalizePlaceText(value: string): string | null {
    if (!value) {
      return null;
    }
    const trimmed = value.trim();
    if (!trimmed) {
      return null;
    }
    return trimmed
      .toLowerCase()
      .normalize('NFD')
      .replace(/[\u0300-\u036f]/g, '');
  }

  private hasPostalCode(text: string | null | undefined): boolean {
    if (!text) {
      return false;
    }

    return /\b\d{4,6}\b/.test(text);
  }

  private appendPostalCodeMissing(
    missingFields: string[],
    quoteRequest: { originText?: string | null; destinationText?: string | null },
  ): string[] {
    const missing = new Set(missingFields);

    if (!missing.has('origin')) {
      const originText = quoteRequest.originText?.trim();
      if (originText && !this.hasPostalCode(originText)) {
        missing.add('origin_postal_code');
      }
    }

    if (!missing.has('destination')) {
      const destinationText = quoteRequest.destinationText?.trim();
      if (destinationText && !this.hasPostalCode(destinationText)) {
        missing.add('destination_postal_code');
      }
    }

    return Array.from(missing);
  }

  private formatDateForDisplay(
    value: string | Date | null | undefined,
  ): string | null {
    if (!value) {
      return null;
    }

    if (value instanceof Date) {
      if (Number.isNaN(value.getTime())) {
        return null;
      }

      return new Intl.DateTimeFormat('es-ES', {
        day: '2-digit',
        month: '2-digit',
        year: 'numeric',
        hour: '2-digit',
        minute: '2-digit',
      }).format(value);
    }

    const trimmed = value.trim();
    if (!trimmed) {
      return null;
    }

    const dateOnlyMatch = trimmed.match(/^(\d{4})-(\d{2})-(\d{2})$/);
    if (dateOnlyMatch) {
      return `${dateOnlyMatch[3]}/${dateOnlyMatch[2]}/${dateOnlyMatch[1]}`;
    }

    const dateTimeMatch = trimmed.match(
      /^(\d{4})-(\d{2})-(\d{2})[T ](\d{2}):(\d{2})/,
    );
    if (dateTimeMatch) {
      return `${dateTimeMatch[3]}/${dateTimeMatch[2]}/${dateTimeMatch[1]} ${dateTimeMatch[4]}:${dateTimeMatch[5]}`;
    }

    const parsed = new Date(trimmed);
    if (!Number.isNaN(parsed.getTime())) {
      return new Intl.DateTimeFormat('es-ES', {
        day: '2-digit',
        month: '2-digit',
        year: 'numeric',
        hour: '2-digit',
        minute: '2-digit',
      }).format(parsed);
    }

    return trimmed;
  }

  private async buildOrderSummary(
    context: QuoteContextInterface,
  ): Promise<string> {
    const productText =
      context.quoteRequest.requestedProductText ?? 'producto';
    const productId = context.quoteRequest.requestedProductId ?? null;
    const productEntity =
      productId
        ? await this.catalogRepository.findProductById(productId)
        : productText
          ? await this.catalogRepository.findProductByText(productText)
          : null;

    const categoryName = productEntity?.category?.name ?? null;
    const categoryCode = productEntity?.category?.code ?? null;
    const categoryText = categoryName
      ? ` (categoría ${categoryName})`
      : categoryCode
        ? ` (categoría ${categoryCode})`
        : '';

    const productLabel = `${productText}${categoryText}`;
    const quantity = context.quoteRequest.requestedVolumeLiters;
    const unit = context.quoteRequest.requestedMode ?? 'L';
    const pickupAt =
      this.formatDateForDisplay(
        this.getWizardValue(context, 'requested_date') ??
          context.quoteRequest.requestedLoadDate,
      ) ?? 'pendiente';
    const deliveryAt =
      this.formatDateForDisplay(
        this.getWizardValue(context, 'delivery_deadline') ??
          context.quoteRequest.deliveryDeadlineDatetime,
      ) ?? 'pendiente';
    const origin =
      this.getWizardValue(context, 'origin') ??
      context.quoteRequest.originText ??
      'origen pendiente';
    const destination =
      this.getWizardValue(context, 'destination') ??
      context.quoteRequest.destinationText ??
      'destino pendiente';

    const originAddress =
      this.getWizardValue(context, 'origin_address') ?? null;
    const originContactName =
      this.getWizardValue(context, 'origin_contact_name') ?? null;
    const originContactPhone =
      this.getWizardValue(context, 'origin_contact_phone') ?? null;
    const destinationAddress =
      this.getWizardValue(context, 'destination_address') ?? null;
    const destinationContactName =
      this.getWizardValue(context, 'destination_contact_name') ?? null;
    const destinationContactPhone =
      this.getWizardValue(context, 'destination_contact_phone') ?? null;

    const quantityText =
      typeof quantity === 'number' ? `${quantity} ${unit}` : 'cantidad pendiente';

    const originContactText =
      originContactName || originContactPhone
        ? ` Responsable: ${originContactName ?? 'sin nombre'}${originContactPhone ? ` (${originContactPhone})` : ''}.`
        : '';

    const destinationContactText =
      destinationContactName || destinationContactPhone
        ? ` Responsable: ${destinationContactName ?? 'sin nombre'}${destinationContactPhone ? ` (${destinationContactPhone})` : ''}.`
        : '';

    const originText = `${origin}${
      originAddress ? ` (${originAddress})` : ''
    }.${originContactText}`;
    const destinationText = `${destination}${
      destinationAddress ? ` (${destinationAddress})` : ''
    }.${destinationContactText}`;

    return `Se realizará un transporte de ${quantityText} de ${productLabel} con recogida ${pickupAt} en ${originText} Entrega ${deliveryAt} en ${destinationText}`;
  }
}
