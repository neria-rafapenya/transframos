import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { ConversationController } from './conversation.controller';
import { ConversationService } from './conversation.service';
import { ConversationRepository } from './repositories/conversation.repository';
import { ConversationSessionEntity } from './entities/conversation-session.entity';
import { ConversationMessageEntity } from './entities/conversation-message.entity';
import { ConversationOrchestratorService } from './services/conversation-orchestrator.service';
import { LlmModule } from '../llm/llm.module';
import { WizardModule } from '../wizard/wizard.module';
import { QuoteModule } from '../quote/quote.module';
import { RulesModule } from '../rules/rules.module';
import { PricingModule } from '../pricing/pricing.module';
import { CatalogModule } from '../catalog/catalog.module';
import { OrdersModule } from '../orders/orders.module';
import { UsersModule } from '../users/users.module';

@Module({
  imports: [
    TypeOrmModule.forFeature([
      ConversationSessionEntity,
      ConversationMessageEntity,
    ]),
    LlmModule,
    WizardModule,
    QuoteModule,
    RulesModule,
    PricingModule,
    CatalogModule,
    OrdersModule,
    UsersModule,
  ],
  controllers: [ConversationController],
  providers: [
    ConversationService,
    ConversationRepository,
    ConversationOrchestratorService,
  ],
  exports: [ConversationService, ConversationRepository],
})
export class ConversationModule {}
