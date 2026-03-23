import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { QuoteModule } from '../quote/quote.module';
import { UsersModule } from '../users/users.module';
import { CatalogModule } from '../catalog/catalog.module';
import { OrdersController } from './orders.controller';
import { OrdersService } from './orders.service';
import { OrdersRepository } from './repositories/orders.repository';
import { DraftOrderEntity } from './entities/draft-order.entity';
import { OrderEntity } from './entities/order.entity';
import { ClientEntity } from '../clients/entities/client.entity';

@Module({
  imports: [
    TypeOrmModule.forFeature([DraftOrderEntity, OrderEntity, ClientEntity]),
    QuoteModule,
    UsersModule,
    CatalogModule,
  ],
  controllers: [OrdersController],
  providers: [OrdersService, OrdersRepository],
  exports: [OrdersService, OrdersRepository],
})
export class OrdersModule {}
