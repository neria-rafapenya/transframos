import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { randomUUID } from 'crypto';
import { Repository } from 'typeorm';
import { DraftOrderEntity } from '../entities/draft-order.entity';
import { OrderEntity } from '../entities/order.entity';

type CreateDraftOrderParams = {
  quoteRequestId: string;
  quoteOptionId: string | null;
  status: string;
  notes: string | null;
  draftPayloadJson: Record<string, unknown> | null;
};

type UpdateDraftOrderParams = {
  status?: string;
  notes?: string | null;
  draftPayloadJson?: Record<string, unknown> | null;
};

@Injectable()
export class OrdersRepository {
  constructor(
    @InjectRepository(DraftOrderEntity)
    private readonly draftOrderRepository: Repository<DraftOrderEntity>,
    @InjectRepository(OrderEntity)
    private readonly orderRepository: Repository<OrderEntity>,
  ) {}

  async createDraftOrder(params: CreateDraftOrderParams) {
    const entity = this.draftOrderRepository.create({
      id: randomUUID(),
      quoteRequestId: params.quoteRequestId,
      quoteOptionId: params.quoteOptionId,
      status: params.status,
      notes: params.notes,
      draftPayloadJson: params.draftPayloadJson
        ? JSON.stringify(params.draftPayloadJson)
        : null,
    });

    return this.draftOrderRepository.save(entity);
  }

  async findDraftOrderById(id: string) {
    return this.draftOrderRepository.findOne({
      where: { id },
    });
  }

  async findDraftOrdersByQuoteRequestId(quoteRequestId: string) {
    return this.draftOrderRepository.find({
      where: { quoteRequestId },
      order: {
        createdAt: 'DESC',
      },
    });
  }

  async updateDraftOrder(id: string, params: UpdateDraftOrderParams) {
    const existing = await this.findDraftOrderById(id);

    if (!existing) {
      return null;
    }

    const merged = this.draftOrderRepository.merge(existing, {
      status:
        typeof params.status !== 'undefined' ? params.status : existing.status,
      notes:
        typeof params.notes !== 'undefined' ? params.notes : existing.notes,
      draftPayloadJson:
        typeof params.draftPayloadJson !== 'undefined'
          ? params.draftPayloadJson
            ? JSON.stringify(params.draftPayloadJson)
            : null
          : existing.draftPayloadJson,
    });

    return this.draftOrderRepository.save(merged);
  }

  async createOrder(params: {
    id: string;
    orderNumber: string;
    clientId: string;
    quoteId: string | null;
    productId: string;
    categoryId: string;
    originLoadingPointId: string;
    destinationUnloadingPointId: string;
    requestedPickupDatetime: Date | null;
    requestedDeliveryDatetime: Date | null;
    confirmedPickupDatetime: Date | null;
    confirmedDeliveryDatetime: Date | null;
    orderedVolumeLiters: number;
    orderedWeightTn: number | null;
    serviceMode: string;
    orderStatus: string;
    priorityLevel: string | null;
    clientReference: string | null;
    internalNotes: string | null;
  }) {
    const entity = this.orderRepository.create({
      id: params.id,
      orderNumber: params.orderNumber,
      clientId: params.clientId,
      quoteId: params.quoteId,
      productId: params.productId,
      categoryId: params.categoryId,
      originLoadingPointId: params.originLoadingPointId,
      destinationUnloadingPointId: params.destinationUnloadingPointId,
      requestedPickupDatetime: params.requestedPickupDatetime,
      requestedDeliveryDatetime: params.requestedDeliveryDatetime,
      confirmedPickupDatetime: params.confirmedPickupDatetime,
      confirmedDeliveryDatetime: params.confirmedDeliveryDatetime,
      orderedVolumeLiters: params.orderedVolumeLiters,
      orderedWeightTn: params.orderedWeightTn,
      serviceMode: params.serviceMode,
      orderStatus: params.orderStatus,
      priorityLevel: params.priorityLevel,
      clientReference: params.clientReference,
      internalNotes: params.internalNotes,
    });

    return this.orderRepository.save(entity);
  }

  async findOrderById(id: string) {
    return this.orderRepository.findOne({ where: { id } });
  }

  async findOrderByOrderNumber(orderNumber: string) {
    return this.orderRepository.findOne({ where: { orderNumber } });
  }

  async findOrderByClientReference(clientReference: string) {
    return this.orderRepository.findOne({
      where: { clientReference },
    });
  }

  async findOrdersByClientId(clientId: string, limit = 50) {
    return this.orderRepository.find({
      where: { clientId },
      order: { createdAt: 'DESC' },
      take: limit,
    });
  }
}
