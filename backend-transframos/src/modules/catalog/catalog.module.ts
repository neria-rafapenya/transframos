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
      TankEntity,
      TankProductAuthorizationEntity,
      VehicleTankEntity,
    ]),
  ],
  controllers: [CatalogController],
  providers: [CatalogService, CatalogRepository],
  exports: [CatalogService, CatalogRepository],
})
export class CatalogModule {}
