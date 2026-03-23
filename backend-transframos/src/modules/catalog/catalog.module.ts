import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { CatalogController } from './catalog.controller';
import { CatalogService } from './catalog.service';
import { CatalogRepository } from './repositories/catalog.repository';
import { ProductEntity } from './entities/product.entity';
import { ProductCategoryEntity } from './entities/product-category.entity';
import { ProductCompatibilityRuleEntity } from './entities/product-compatibility-rule.entity';
import { VehicleEntity } from './entities/vehicle.entity';
import { VehicleAvailabilityEntity } from './entities/vehicle-availability.entity';
import { LoadingPointEntity } from './entities/loading-point.entity';
import { UnloadingPointEntity } from './entities/unloading-point.entity';
import { RouteEntity } from './entities/route.entity';
import { TankEntity } from './entities/tank.entity';
import { TankProductAuthorizationEntity } from './entities/tank-product-authorization.entity';
import { VehicleTankEntity } from './entities/vehicle-tank.entity';
import { VehicleRouteEntity } from './entities/vehicle-route.entity';
import { RouteWaypointEntity } from './entities/route-waypoint.entity';
import { RouteSuggestionService } from './services/route-suggestion.service';
import { LlmModule } from '../llm/llm.module';

@Module({
  imports: [
    TypeOrmModule.forFeature([
      ProductEntity,
      ProductCategoryEntity,
      ProductCompatibilityRuleEntity,
      VehicleEntity,
      VehicleAvailabilityEntity,
      LoadingPointEntity,
      UnloadingPointEntity,
      RouteEntity,
      RouteWaypointEntity,
      TankEntity,
      TankProductAuthorizationEntity,
      VehicleTankEntity,
      VehicleRouteEntity,
    ]),
    LlmModule,
  ],
  controllers: [CatalogController],
  providers: [CatalogService, CatalogRepository, RouteSuggestionService],
  exports: [CatalogService, CatalogRepository, RouteSuggestionService],
})
export class CatalogModule {}
