import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { randomUUID } from 'crypto';
import { Repository } from 'typeorm';
import { QuoteOptionEntity } from '../entities/quote-option.entity';
import { QuoteRequestEntity } from '../entities/quote-request.entity';
import { ValidationResultEntity } from '../entities/validation-result.entity';

type CreateQuoteRequestParams = {
  conversationSessionId: string | null;
  sourceChannel: string;
};

type UpdateQuoteRequestParams = {
  requestedProductText?: string;
  requestedVolumeLiters?: number | null;
  requestedMode?: string | null;
  originText?: string | null;
  destinationText?: string | null;
  requestedLoadDate?: string | null;
  deliveryDeadlineDatetime?: Date | null;
  extractedJson?: Record<string, unknown> | null;
  requestedProductId?: string | null;
  originLoadingPointId?: string | null;
  destinationUnloadingPointId?: string | null;
  clientId?: string | null;
  validationStatus?: string;
  wizardStatus?: string;
  suggestedRouteId?: string | null;
  suggestedRouteCode?: string | null;
  suggestedRouteConfidence?: number | null;
  suggestedRouteRationale?: string | null;
  suggestedRouteAccepted?: boolean | null;
};

@Injectable()
export class QuoteRepository {
  constructor(
    @InjectRepository(QuoteRequestEntity)
    private readonly quoteRequestRepository: Repository<QuoteRequestEntity>,
    @InjectRepository(QuoteOptionEntity)
    private readonly quoteOptionRepository: Repository<QuoteOptionEntity>,
    @InjectRepository(ValidationResultEntity)
    private readonly validationResultRepository: Repository<ValidationResultEntity>,
  ) {}

  async createQuoteRequest(params: CreateQuoteRequestParams) {
    const entity = this.quoteRequestRepository.create({
      id: randomUUID(),
      conversationSessionId: params.conversationSessionId,
      externalReference: params.conversationSessionId,
      sourceChannel: params.sourceChannel,
      clientId: null,
      requesterName: null,
      requesterEmail: null,
      requesterPhone: null,
      requestedProductText: 'Pendiente',
      requestedProductId: null,
      requestedCategoryId: null,
      requestedVolumeLiters: null,
      requestedWeightTn: null,
      requestedLoadDate: null,
      originText: null,
      destinationText: null,
      originLoadingPointId: null,
      destinationUnloadingPointId: null,
      serviceConstraintsText: null,
      requestedMode: null,
      extractedJson: null,
      validationStatus: 'pending',
      deliveryDeadlineDatetime: null,
      wizardStatus: 'idle',
      suggestedRouteId: null,
      suggestedRouteCode: null,
      suggestedRouteConfidence: null,
      suggestedRouteRationale: null,
      suggestedRouteAccepted: null,
    });

    return this.quoteRequestRepository.save(entity);
  }

  async findQuoteRequestById(id: string) {
    return this.quoteRequestRepository.findOne({
      where: { id },
    });
  }

  async findQuoteRequestByConversationSessionId(conversationSessionId: string) {
    return this.quoteRequestRepository.findOne({
      where: { conversationSessionId },
    });
  }

  async updateQuoteRequest(id: string, params: UpdateQuoteRequestParams) {
    const existing = await this.findQuoteRequestById(id);

    if (!existing) {
      return null;
    }

    const merged = this.quoteRequestRepository.merge(existing, {
      requestedProductText:
        typeof params.requestedProductText !== 'undefined'
          ? params.requestedProductText
          : existing.requestedProductText,
      requestedVolumeLiters:
        typeof params.requestedVolumeLiters !== 'undefined'
          ? params.requestedVolumeLiters
          : existing.requestedVolumeLiters,
      requestedMode:
        typeof params.requestedMode !== 'undefined'
          ? params.requestedMode
          : existing.requestedMode,
      originText:
        typeof params.originText !== 'undefined'
          ? params.originText
          : existing.originText,
      destinationText:
        typeof params.destinationText !== 'undefined'
          ? params.destinationText
          : existing.destinationText,
      requestedLoadDate:
        typeof params.requestedLoadDate !== 'undefined'
          ? params.requestedLoadDate
          : existing.requestedLoadDate,
      deliveryDeadlineDatetime:
        typeof params.deliveryDeadlineDatetime !== 'undefined'
          ? params.deliveryDeadlineDatetime
          : existing.deliveryDeadlineDatetime,
      extractedJson:
        typeof params.extractedJson !== 'undefined'
          ? params.extractedJson
            ? JSON.stringify(params.extractedJson)
            : null
          : existing.extractedJson,
      requestedProductId:
        typeof params.requestedProductId !== 'undefined'
          ? params.requestedProductId
          : existing.requestedProductId,
      originLoadingPointId:
        typeof params.originLoadingPointId !== 'undefined'
          ? params.originLoadingPointId
          : existing.originLoadingPointId,
      destinationUnloadingPointId:
        typeof params.destinationUnloadingPointId !== 'undefined'
          ? params.destinationUnloadingPointId
          : existing.destinationUnloadingPointId,
      clientId:
        typeof params.clientId !== 'undefined'
          ? params.clientId
          : existing.clientId,
      validationStatus:
        typeof params.validationStatus !== 'undefined'
          ? params.validationStatus
          : existing.validationStatus,
      wizardStatus:
        typeof params.wizardStatus !== 'undefined'
          ? params.wizardStatus
          : existing.wizardStatus,
      suggestedRouteId:
        typeof params.suggestedRouteId !== 'undefined'
          ? params.suggestedRouteId
          : existing.suggestedRouteId,
      suggestedRouteCode:
        typeof params.suggestedRouteCode !== 'undefined'
          ? params.suggestedRouteCode
          : existing.suggestedRouteCode,
      suggestedRouteConfidence:
        typeof params.suggestedRouteConfidence !== 'undefined'
          ? params.suggestedRouteConfidence
          : existing.suggestedRouteConfidence,
      suggestedRouteRationale:
        typeof params.suggestedRouteRationale !== 'undefined'
          ? params.suggestedRouteRationale
          : existing.suggestedRouteRationale,
      suggestedRouteAccepted:
        typeof params.suggestedRouteAccepted !== 'undefined'
          ? params.suggestedRouteAccepted
          : existing.suggestedRouteAccepted,
    });

    return this.quoteRequestRepository.save(merged);
  }

  async findQuoteOptionsByRequestId(quoteRequestId: string) {
    return this.quoteOptionRepository.find({
      where: { quoteRequestId },
      order: {
        recommendationScore: 'DESC',
        estimatedCost: 'ASC',
      },
    });
  }

  async findValidationResultsByRequestId(quoteRequestId: string) {
    return this.validationResultRepository.find({
      where: { quoteRequestId },
      order: {
        createdAt: 'ASC',
      },
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
    const entity = this.quoteOptionRepository.create({
      id: randomUUID(),
      quoteRequestId: params.quoteRequestId,
      vehicleTypeId: params.vehicleTypeId,
      cleaningProtocolId: params.cleaningProtocolId,
      estimatedCost: params.estimatedCost,
      estimatedTransitHours: params.estimatedTransitHours,
      isFeasible: params.isFeasible,
      recommendationScore: params.recommendationScore,
      reasoningJson: params.reasoningJson
        ? JSON.stringify(params.reasoningJson)
        : null,
      notes: params.notes,
    });

    return this.quoteOptionRepository.save(entity);
  }

  async deleteQuoteOptionsByRequestId(quoteRequestId: string) {
    await this.quoteOptionRepository.delete({
      quoteRequestId,
    });
  }
}
