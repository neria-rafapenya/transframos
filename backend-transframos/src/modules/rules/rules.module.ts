import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { QuoteModule } from '../quote/quote.module';
import { CatalogModule } from '../catalog/catalog.module';
import { ValidationResultEntity } from '../quote/entities/validation-result.entity';
import { RulesController } from './rules.controller';
import { RulesService } from './rules.service';
import { RulesRepository } from './repositories/rules.repository';
import { CompatibilityRulesService } from './services/compatibility-rules.service';
import { CleaningRulesService } from './services/cleaning-rules.service';
import { LeadTimeRulesService } from './services/lead-time-rules.service';

@Module({
  imports: [
    TypeOrmModule.forFeature([ValidationResultEntity]),
    QuoteModule,
    CatalogModule,
  ],
  controllers: [RulesController],
  providers: [
    RulesService,
    RulesRepository,
    CompatibilityRulesService,
    CleaningRulesService,
    LeadTimeRulesService,
  ],
  exports: [RulesService, RulesRepository],
})
export class RulesModule {}
