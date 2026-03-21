import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { randomUUID } from 'crypto';
import { Repository } from 'typeorm';
import { DraftOrderEntity } from '../entities/draft-order.entity';

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
}
