import { Module } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { TypeOrmModule } from '@nestjs/typeorm';

import { User } from '../modules/users/entities/user.entity';
import { AuthSession } from '../modules/sessions/entities/auth-session.entity';
import { LlmAction } from '../modules/llm/entities/llm-action.entity';

import { ConversationSessionEntity } from '../modules/conversation/entities/conversation-session.entity';
import { ConversationMessageEntity } from '../modules/conversation/entities/conversation-message.entity';

import { WizardStepEntity } from '../modules/wizard/entities/wizard-step.entity';
import { SessionStepStateEntity } from '../modules/wizard/entities/session-step-state.entity';

import { QuoteRequestEntity } from '../modules/quote/entities/quote-request.entity';
import { QuoteOptionEntity } from '../modules/quote/entities/quote-option.entity';
import { ValidationResultEntity } from '../modules/quote/entities/validation-result.entity';

import { DraftOrderEntity } from '../modules/orders/entities/draft-order.entity';
import { OrderEntity } from '../modules/orders/entities/order.entity';
import { ClientEntity } from '../modules/clients/entities/client.entity';
import { VehicleEntity } from '../modules/catalog/entities/vehicle.entity';
import { VehicleAvailabilityEntity } from '../modules/catalog/entities/vehicle-availability.entity';
import { ProductEntity } from '../modules/catalog/entities/product.entity';
import { ProductCategoryEntity } from '../modules/catalog/entities/product-category.entity';
import { ProductCompatibilityRuleEntity } from '../modules/catalog/entities/product-compatibility-rule.entity';
import { LoadingPointEntity } from '../modules/catalog/entities/loading-point.entity';
import { UnloadingPointEntity } from '../modules/catalog/entities/unloading-point.entity';
import { RouteEntity } from '../modules/catalog/entities/route.entity';
import { RouteWaypointEntity } from '../modules/catalog/entities/route-waypoint.entity';
import { TankEntity } from '../modules/catalog/entities/tank.entity';
import { TankProductAuthorizationEntity } from '../modules/catalog/entities/tank-product-authorization.entity';
import { VehicleTankEntity } from '../modules/catalog/entities/vehicle-tank.entity';
import { VehicleRouteEntity } from '../modules/catalog/entities/vehicle-route.entity';

@Module({
  imports: [
    TypeOrmModule.forRootAsync({
      inject: [ConfigService],
      useFactory: (configService: ConfigService) => {
        const syncRaw = configService.get<string>('DB_SYNCHRONIZE');
        const synchronize = syncRaw
          ? ['true', '1', 'yes', 'y'].includes(syncRaw.trim().toLowerCase())
          : false;

        return {
          type: 'mysql' as const,
          host: configService.get<string>('DB_HOST'),
          port: Number(configService.get<string>('DB_PORT')),
          username: configService.get<string>('DB_USERNAME'),
          password: configService.get<string>('DB_PASSWORD'),
          database: configService.get<string>('DB_NAME'),
          entities: [
            User,
            AuthSession,
            LlmAction,
            ConversationSessionEntity,
            ConversationMessageEntity,
            WizardStepEntity,
            SessionStepStateEntity,
            QuoteRequestEntity,
            QuoteOptionEntity,
            ValidationResultEntity,
            DraftOrderEntity,
            OrderEntity,
            ClientEntity,
            VehicleEntity,
            VehicleAvailabilityEntity,
            ProductEntity,
            ProductCategoryEntity,
            ProductCompatibilityRuleEntity,
            LoadingPointEntity,
            UnloadingPointEntity,
            RouteEntity,
            RouteWaypointEntity,
            TankEntity,
            TankProductAuthorizationEntity,
            VehicleTankEntity,
            VehicleRouteEntity,
          ],
          synchronize,
          logging: false,
        };
      },
    }),
  ],
})
export class DatabaseModule {}
