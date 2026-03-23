import { Injectable, NotFoundException } from '@nestjs/common';
import { QuoteService } from '../quote/quote.service';
import { PricingEngineService } from './services/pricing-engine.service';

@Injectable()
export class PricingService {
  constructor(
    private readonly quoteService: QuoteService,
    private readonly pricingEngineService: PricingEngineService,
  ) {}

  async calculateBestOption(quoteRequestId: string) {
    const quoteRequest =
      await this.quoteService.getQuoteRequestEntityById(quoteRequestId);

    if (!quoteRequest) {
      throw new NotFoundException(
        `No existe ninguna solicitud de presupuesto con id ${quoteRequestId}`,
      );
    }

    await this.quoteService.deleteQuoteOptionsByRequestId(quoteRequestId);

    const option = await this.pricingEngineService.buildOption(quoteRequest);

    if (option.routeSuggestion) {
      await this.quoteService.updateRouteSuggestion(quoteRequestId, {
        suggestedRouteId: option.routeSuggestion.suggestedRouteId ?? null,
        suggestedRouteCode: option.routeSuggestion.suggestedRouteCode ?? null,
        suggestedRouteConfidence:
          typeof option.routeSuggestion.suggestedRouteConfidence === 'number'
            ? option.routeSuggestion.suggestedRouteConfidence
            : null,
        suggestedRouteRationale:
          option.routeSuggestion.suggestedRouteRationale ?? null,
        suggestedRouteAccepted:
          typeof option.routeSuggestion.suggestedRouteAccepted === 'boolean'
            ? option.routeSuggestion.suggestedRouteAccepted
            : null,
      });
    }

    if (!option.isFeasible) {
      return null;
    }

    return this.quoteService.createQuoteOption({
      quoteRequestId,
      vehicleTypeId: option.vehicleTypeId,
      cleaningProtocolId: option.cleaningProtocolId,
      estimatedCost: option.estimatedCost,
      estimatedTransitHours: option.estimatedTransitHours,
      isFeasible: option.isFeasible,
      recommendationScore: option.recommendationScore,
      reasoningJson: option.reasoningJson,
      notes: option.notes,
    });
  }
}
