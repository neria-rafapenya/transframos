import { Body, Controller, Get, Param, Patch, Post } from '@nestjs/common';
import { QuoteService } from './quote.service';

@Controller('quotes')
export class QuoteController {
  constructor(private readonly quoteService: QuoteService) {}

  @Get(':id')
  async getQuoteRequestById(@Param('id') id: string) {
    return this.quoteService.getQuoteRequestById(id);
  }

  @Get(':id/options')
  async getQuoteOptions(@Param('id') id: string) {
    return this.quoteService.getQuoteOptions(id);
  }

  @Get(':id/validations')
  async getValidationResults(@Param('id') id: string) {
    return this.quoteService.getValidationResults(id);
  }

  @Patch(':id/validation-status')
  async updateValidationStatus(
    @Param('id') id: string,
    @Body() body: { validationStatus: string },
  ) {
    return this.quoteService.updateQuoteRequestValidationStatus(
      id,
      body.validationStatus,
    );
  }

  @Patch(':id/data')
  async updateQuoteRequestData(
    @Param('id') id: string,
    @Body()
    body: {
      productId?: string | null;
      quantityValue?: number | null;
      quantityUnit?: string | null;
      originLocationId?: string | null;
      destinationLocationId?: string | null;
      requestedPickupAt?: string | null;
      deliveryDeadlineAt?: string | null;
      rawRequestJson?: Record<string, unknown> | null;
      validationStatus?: string;
      wizardStatus?: string;
      quoteStatus?: string;
    },
  ) {
    return this.quoteService.updateQuoteRequestData(id, {
      productId: body.productId,
      quantityValue: body.quantityValue,
      quantityUnit: body.quantityUnit,
      originLocationId: body.originLocationId,
      destinationLocationId: body.destinationLocationId,
      requestedPickupAt: body.requestedPickupAt
        ? new Date(body.requestedPickupAt)
        : body.requestedPickupAt === null
          ? null
          : undefined,
      deliveryDeadlineAt: body.deliveryDeadlineAt
        ? new Date(body.deliveryDeadlineAt)
        : body.deliveryDeadlineAt === null
          ? null
          : undefined,
      rawRequestJson: body.rawRequestJson,
      validationStatus: body.validationStatus,
      wizardStatus: body.wizardStatus,
      quoteStatus: body.quoteStatus,
    });
  }

  @Post(':id/options')
  async createQuoteOption(
    @Param('id') id: string,
    @Body()
    body: {
      vehicleTypeId: string | null;
      cleaningProtocolId: string | null;
      estimatedCost: number | null;
      estimatedTransitHours: number | null;
      isFeasible: boolean;
      recommendationScore: number | null;
      reasoningJson: Record<string, unknown> | null;
      notes: string | null;
    },
  ) {
    return this.quoteService.createQuoteOption({
      quoteRequestId: id,
      vehicleTypeId: body.vehicleTypeId,
      cleaningProtocolId: body.cleaningProtocolId,
      estimatedCost: body.estimatedCost,
      estimatedTransitHours: body.estimatedTransitHours,
      isFeasible: body.isFeasible,
      recommendationScore: body.recommendationScore,
      reasoningJson: body.reasoningJson,
      notes: body.notes,
    });
  }

  @Post(':id/options/clear')
  async clearQuoteOptions(@Param('id') id: string) {
    return this.quoteService.deleteQuoteOptionsByRequestId(id);
  }
}
