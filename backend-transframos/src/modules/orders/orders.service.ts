import { Injectable, NotFoundException } from '@nestjs/common';
import { QuoteService } from '../quote/quote.service';
import { CreateDraftOrderDto } from './dto/create-draft-order.dto';
import { OrdersRepository } from './repositories/orders.repository';

@Injectable()
export class OrdersService {
  constructor(
    private readonly ordersRepository: OrdersRepository,
    private readonly quoteService: QuoteService,
  ) {}

  async createDraftOrder(dto: CreateDraftOrderDto) {
    const quoteRequestId = String(dto.quoteRequestId);
    const quoteOptionId =
      dto.quoteOptionId !== null && typeof dto.quoteOptionId !== 'undefined'
        ? String(dto.quoteOptionId)
        : null;

    const quoteResponse =
      await this.quoteService.getQuoteRequestById(quoteRequestId);
    const quoteRequest = quoteResponse.quoteRequest;

    if (!quoteRequest) {
      throw new NotFoundException(
        `No existe ninguna solicitud de presupuesto con id ${quoteRequestId}`,
      );
    }

    const selectedOption = quoteOptionId
      ? (quoteResponse.quoteOptions.find((item) => item.id === quoteOptionId) ??
        null)
      : null;

    const payload: Record<string, unknown> = {
      quoteRequestId: quoteRequest.id,
      quoteOptionId: selectedOption?.id ?? null,
      requestedProductText: quoteRequest.requestedProductText,
      requestedProductId: quoteRequest.requestedProductId,
      requestedVolumeLiters: quoteRequest.requestedVolumeLiters,
      requestedMode: quoteRequest.requestedMode,
      originText: quoteRequest.originText,
      destinationText: quoteRequest.destinationText,
      originLoadingPointId: quoteRequest.originLoadingPointId,
      destinationUnloadingPointId: quoteRequest.destinationUnloadingPointId,
      requestedLoadDate: quoteRequest.requestedLoadDate,
      deliveryDeadlineDatetime: quoteRequest.deliveryDeadlineDatetime,
      estimatedCost: selectedOption?.estimatedCost ?? null,
      estimatedTransitHours: selectedOption?.estimatedTransitHours ?? null,
      vehicleTypeId: selectedOption?.vehicleTypeId ?? null,
      cleaningProtocolId: selectedOption?.cleaningProtocolId ?? null,
    };

    return this.ordersRepository.createDraftOrder({
      quoteRequestId,
      quoteOptionId,
      status: dto.status ?? 'draft',
      notes: dto.notes ?? null,
      draftPayloadJson:
        dto.draftPayloadJson ?? (payload as Record<string, unknown>),
    });
  }

  async getDraftOrderById(id: string) {
    const draft = await this.ordersRepository.findDraftOrderById(String(id));

    if (!draft) {
      throw new NotFoundException(
        `No existe ningún borrador de orden con id ${id}`,
      );
    }

    return draft;
  }

  async getDraftOrdersByQuoteRequestId(quoteRequestId: string) {
    return this.ordersRepository.findDraftOrdersByQuoteRequestId(
      String(quoteRequestId),
    );
  }

  async updateDraftOrderStatus(id: string, status: string) {
    const draft = await this.ordersRepository.findDraftOrderById(String(id));

    if (!draft) {
      throw new NotFoundException(
        `No existe ningún borrador de orden con id ${id}`,
      );
    }

    return this.ordersRepository.updateDraftOrder(String(id), {
      status,
    });
  }
}
