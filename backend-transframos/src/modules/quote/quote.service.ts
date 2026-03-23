import { Injectable, NotFoundException } from '@nestjs/common';
import type { LlmExtractionInterface } from '../../common/interfaces/transport/llm-extraction.interface';
import { QuoteRepository } from './repositories/quote.repository';

@Injectable()
export class QuoteService {
  constructor(private readonly quoteRepository: QuoteRepository) {}

  async findOrCreateByConversationSessionId(conversationSessionId: string) {
    const existing =
      await this.quoteRepository.findQuoteRequestByConversationSessionId(
        conversationSessionId,
      );

    if (existing) {
      return existing;
    }

    return this.quoteRepository.createQuoteRequest({
      conversationSessionId,
      sourceChannel: 'chat',
    });
  }

  async getQuoteRequestById(id: string) {
    const quoteRequest = await this.quoteRepository.findQuoteRequestById(id);

    if (!quoteRequest) {
      throw new NotFoundException(
        `No existe ninguna solicitud de presupuesto con id ${id}`,
      );
    }

    const validationResults =
      await this.quoteRepository.findValidationResultsByRequestId(id);
    const quoteOptions =
      await this.quoteRepository.findQuoteOptionsByRequestId(id);

    return {
      quoteRequest,
      validationResults,
      quoteOptions,
    };
  }

  async getQuoteRequestEntityById(id: string) {
    const quoteRequest = await this.quoteRepository.findQuoteRequestById(id);

    if (!quoteRequest) {
      throw new NotFoundException(
        `No existe ninguna solicitud de presupuesto con id ${id}`,
      );
    }

    return quoteRequest;
  }

  async getQuoteOptions(id: string) {
    return this.quoteRepository.findQuoteOptionsByRequestId(id);
  }

  async findQuoteRequestByConversationSessionId(
    conversationSessionId: string,
  ) {
    return this.quoteRepository.findQuoteRequestByConversationSessionId(
      conversationSessionId,
    );
  }

  async getValidationResults(id: string) {
    return this.quoteRepository.findValidationResultsByRequestId(id);
  }

  async updateQuoteRequestValidationStatus(
    id: string,
    validationStatus: string,
  ) {
    const quoteRequest = await this.quoteRepository.findQuoteRequestById(id);

    if (!quoteRequest) {
      throw new NotFoundException(
        `No existe ninguna solicitud de presupuesto con id ${id}`,
      );
    }

    return this.quoteRepository.updateQuoteRequest(id, {
      validationStatus,
    });
  }

  async updateQuoteRequestData(
    id: string,
    params: {
      productText?: string | null;
      productId?: string | null;
      categoryId?: string | null;
      quantityValue?: number | null;
      quantityUnit?: string | null;
      originLocationId?: string | null;
      destinationLocationId?: string | null;
      originText?: string | null;
      destinationText?: string | null;
      requestedPickupAt?: Date | null;
      deliveryDeadlineAt?: Date | null;
      rawRequestJson?: Record<string, unknown> | null;
      validationStatus?: string;
      wizardStatus?: string;
      quoteStatus?: string;
      suggestedRouteId?: string | null;
      suggestedRouteCode?: string | null;
      suggestedRouteConfidence?: number | null;
      suggestedRouteRationale?: string | null;
      suggestedRouteAccepted?: boolean | null;
      clientId?: string | null;
    },
  ) {
    const quoteRequest = await this.quoteRepository.findQuoteRequestById(id);

    if (!quoteRequest) {
      throw new NotFoundException(
        `No existe ninguna solicitud de presupuesto con id ${id}`,
      );
    }

    return this.quoteRepository.updateQuoteRequest(id, {
      requestedProductText:
        typeof params.productText !== 'undefined'
          ? params.productText ?? 'Pendiente'
          : undefined,
      requestedProductId:
        typeof params.productId !== 'undefined'
          ? params.productId !== null
            ? String(params.productId)
            : null
          : undefined,
      requestedCategoryId:
        typeof params.categoryId !== 'undefined'
          ? params.categoryId !== null
            ? String(params.categoryId)
            : null
          : undefined,
      requestedVolumeLiters:
        typeof params.quantityValue !== 'undefined'
          ? params.quantityValue
          : undefined,
      requestedMode:
        typeof params.quantityUnit !== 'undefined'
          ? params.quantityUnit
          : undefined,
      originText:
        typeof params.originText !== 'undefined'
          ? params.originText
          : undefined,
      destinationText:
        typeof params.destinationText !== 'undefined'
          ? params.destinationText
          : undefined,
      originLoadingPointId:
        typeof params.originLocationId !== 'undefined'
          ? params.originLocationId !== null
            ? String(params.originLocationId)
            : null
          : undefined,
      destinationUnloadingPointId:
        typeof params.destinationLocationId !== 'undefined'
          ? params.destinationLocationId !== null
            ? String(params.destinationLocationId)
            : null
          : undefined,
      clientId:
        typeof params.clientId !== 'undefined'
          ? params.clientId !== null
            ? String(params.clientId)
            : null
          : undefined,
      requestedLoadDate:
        typeof params.requestedPickupAt !== 'undefined'
          ? params.requestedPickupAt
            ? params.requestedPickupAt.toISOString().slice(0, 10)
            : null
          : undefined,
      deliveryDeadlineDatetime:
        typeof params.deliveryDeadlineAt !== 'undefined'
          ? params.deliveryDeadlineAt
          : undefined,
      extractedJson:
        typeof params.rawRequestJson !== 'undefined'
          ? params.rawRequestJson
          : undefined,
      validationStatus:
        typeof params.validationStatus !== 'undefined'
          ? params.validationStatus
          : undefined,
      wizardStatus:
        typeof params.wizardStatus !== 'undefined'
          ? params.wizardStatus
          : undefined,
      suggestedRouteId:
        typeof params.suggestedRouteId !== 'undefined'
          ? params.suggestedRouteId
          : undefined,
      suggestedRouteCode:
        typeof params.suggestedRouteCode !== 'undefined'
          ? params.suggestedRouteCode
          : undefined,
      suggestedRouteConfidence:
        typeof params.suggestedRouteConfidence !== 'undefined'
          ? params.suggestedRouteConfidence
          : undefined,
      suggestedRouteRationale:
        typeof params.suggestedRouteRationale !== 'undefined'
          ? params.suggestedRouteRationale
          : undefined,
      suggestedRouteAccepted:
        typeof params.suggestedRouteAccepted !== 'undefined'
          ? params.suggestedRouteAccepted
          : undefined,
    });
  }

  async updateRouteSuggestion(
    id: string,
    params: {
      suggestedRouteId?: string | null;
      suggestedRouteCode?: string | null;
      suggestedRouteConfidence?: number | null;
      suggestedRouteRationale?: string | null;
      suggestedRouteAccepted?: boolean | null;
    },
  ) {
    const quoteRequest = await this.quoteRepository.findQuoteRequestById(id);

    if (!quoteRequest) {
      throw new NotFoundException(
        `No existe ninguna solicitud de presupuesto con id ${id}`,
      );
    }

    return this.quoteRepository.updateQuoteRequest(id, {
      suggestedRouteId:
        typeof params.suggestedRouteId !== 'undefined'
          ? params.suggestedRouteId
          : undefined,
      suggestedRouteCode:
        typeof params.suggestedRouteCode !== 'undefined'
          ? params.suggestedRouteCode
          : undefined,
      suggestedRouteConfidence:
        typeof params.suggestedRouteConfidence !== 'undefined'
          ? params.suggestedRouteConfidence
          : undefined,
      suggestedRouteRationale:
        typeof params.suggestedRouteRationale !== 'undefined'
          ? params.suggestedRouteRationale
          : undefined,
      suggestedRouteAccepted:
        typeof params.suggestedRouteAccepted !== 'undefined'
          ? params.suggestedRouteAccepted
          : undefined,
    });
  }

  async upsertFromExtraction(id: string, extraction: LlmExtractionInterface) {
    const quoteRequest = await this.quoteRepository.findQuoteRequestById(id);

    if (!quoteRequest) {
      throw new NotFoundException(
        `No existe ninguna solicitud de presupuesto con id ${id}`,
      );
    }

    const hasValue = <T>(value: T | null | undefined): value is T =>
      value !== null && typeof value !== 'undefined';

    return this.quoteRepository.updateQuoteRequest(id, {
      requestedProductText:
        extraction.extractedFields.productText ??
        quoteRequest.requestedProductText,
      requestedVolumeLiters:
        hasValue(extraction.extractedFields.quantityValue)
          ? extraction.extractedFields.quantityValue
          : undefined,
      requestedMode:
        hasValue(extraction.extractedFields.quantityUnit)
          ? extraction.extractedFields.quantityUnit
          : undefined,
      originText:
        hasValue(extraction.extractedFields.originText)
          ? extraction.extractedFields.originText
          : undefined,
      destinationText:
        hasValue(extraction.extractedFields.destinationText)
          ? extraction.extractedFields.destinationText
          : undefined,
      requestedLoadDate:
        hasValue(extraction.extractedFields.requestedPickupAt)
          ? extraction.extractedFields.requestedPickupAt
            ? extraction.extractedFields.requestedPickupAt.slice(0, 10)
            : null
          : undefined,
      deliveryDeadlineDatetime:
        hasValue(extraction.extractedFields.deliveryDeadlineAt)
          ? extraction.extractedFields.deliveryDeadlineAt
            ? new Date(extraction.extractedFields.deliveryDeadlineAt)
            : null
          : undefined,
      extractedJson: {
        extraction,
      },
      wizardStatus: 'collecting_data',
    });
  }

  async createQuoteOption(params: {
    quoteRequestId: string;
    vehicleTypeId: string | null;
    cleaningProtocolId: string | null;
    estimatedCost: number | null;
    estimatedTransitHours: number | null;
    isFeasible: boolean;
    recommendationScore: number | null;
    reasoningJson: Record<string, unknown> | null;
    notes: string | null;
  }) {
    return this.quoteRepository.createQuoteOption(params);
  }

  async deleteQuoteOptionsByRequestId(quoteRequestId: string) {
    const quoteRequest =
      await this.quoteRepository.findQuoteRequestById(quoteRequestId);

    if (!quoteRequest) {
      throw new NotFoundException(
        `No existe ninguna solicitud de presupuesto con id ${quoteRequestId}`,
      );
    }

    return this.quoteRepository.deleteQuoteOptionsByRequestId(quoteRequestId);
  }
}
