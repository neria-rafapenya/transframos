import { Controller, Get, Param, Post } from '@nestjs/common';
import { PricingService } from './pricing.service';

@Controller('pricing')
export class PricingController {
  constructor(private readonly pricingService: PricingService) {}

  @Post('quotes/:quoteRequestId/calculate')
  async calculateQuotePricing(@Param('quoteRequestId') quoteRequestId: string) {
    return this.pricingService.calculateBestOption(quoteRequestId);
  }

  @Get('quotes/:quoteRequestId/options')
  async getCalculatedOptions(@Param('quoteRequestId') quoteRequestId: string) {
    const option =
      await this.pricingService.calculateBestOption(quoteRequestId);

    return option ? [option] : [];
  }
}
