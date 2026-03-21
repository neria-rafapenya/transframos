import { Module } from '@nestjs/common';
import { QuoteModule } from '../quote/quote.module';
import { CatalogModule } from '../catalog/catalog.module';
import { PricingService } from './pricing.service';
import { PricingEngineService } from './services/pricing-engine.service';

@Module({
  imports: [QuoteModule, CatalogModule],
  providers: [PricingService, PricingEngineService],
  exports: [PricingService],
})
export class PricingModule {}
