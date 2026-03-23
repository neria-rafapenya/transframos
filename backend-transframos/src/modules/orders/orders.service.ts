import {
  BadRequestException,
  Injectable,
  NotFoundException,
} from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { randomUUID } from 'crypto';
import { Repository } from 'typeorm';
import { CatalogRepository } from '../catalog/repositories/catalog.repository';
import { ClientEntity } from '../clients/entities/client.entity';
import { QuoteService } from '../quote/quote.service';
import { QuoteRequestEntity } from '../quote/entities/quote-request.entity';
import { QuoteOptionEntity } from '../quote/entities/quote-option.entity';
import { UsersService } from '../users/users.service';
import { SessionStepStateEntity } from '../wizard/entities/session-step-state.entity';
import { CreateDraftOrderDto } from './dto/create-draft-order.dto';
import { OrdersRepository } from './repositories/orders.repository';
import {
  buildDecorativeCoordinates,
} from '../../common/utils/decorative-coordinates';

@Injectable()
export class OrdersService {
  constructor(
    private readonly ordersRepository: OrdersRepository,
    private readonly quoteService: QuoteService,
    private readonly usersService: UsersService,
    private readonly catalogRepository: CatalogRepository,
    @InjectRepository(ClientEntity)
    private readonly clientRepository: Repository<ClientEntity>,
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

  async getOrdersForUser(userId: string, limit = 50) {
    const user = await this.usersService.findById(userId);
    if (!user.clientId) {
      return [];
    }

    return this.ordersRepository.findOrdersByClientId(user.clientId, limit);
  }

  async getOrderByIdForUser(userId: string, orderId: string) {
    const user = await this.usersService.findById(userId);
    if (!user.clientId) {
      throw new NotFoundException('Pedido no encontrado');
    }

    const order = await this.ordersRepository.findOrderById(orderId);
    if (!order || order.clientId !== user.clientId) {
      throw new NotFoundException('Pedido no encontrado');
    }

    return order;
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

  async createClosedOrderFromContext(params: {
    quoteRequest: QuoteRequestEntity;
    topOption?: QuoteOptionEntity | null;
    wizardStates: SessionStepStateEntity[];
    userId: string;
  }) {
    const existingDrafts =
      await this.ordersRepository.findDraftOrdersByQuoteRequestId(
        params.quoteRequest.id,
      );
    const closedDraft = existingDrafts.find(
      (draft) => draft.status === 'closed',
    );

    if (closedDraft?.draftPayloadJson) {
      const existingPayload = this.safeParseJson(closedDraft.draftPayloadJson);
      const existingOrderId =
        typeof existingPayload?.orderId === 'string'
          ? existingPayload.orderId
          : null;
      if (existingOrderId) {
        const existingOrder =
          await this.ordersRepository.findOrderById(existingOrderId);
        if (existingOrder) {
          return { order: existingOrder, created: false };
        }
      }
    }

    const clientId = await this.resolveClientId(
      params.userId,
      params.quoteRequest,
    );

    const { productId, categoryId } = await this.resolveProductAndCategory(
      params.quoteRequest,
      params.topOption ?? null,
    );

    const originPoint = await this.resolveLoadingPoint({
      quoteRequest: params.quoteRequest,
      wizardStates: params.wizardStates,
      clientId,
    });

    const destinationPoint = await this.resolveUnloadingPoint({
      quoteRequest: params.quoteRequest,
      wizardStates: params.wizardStates,
      clientId,
    });

    const requestedPickupDatetime = this.resolveDateTime(
      this.getWizardValue(params.wizardStates, 'requested_date'),
      params.quoteRequest.requestedLoadDate,
    );
    const requestedDeliveryDatetime = this.resolveDateTime(
      this.getWizardValue(params.wizardStates, 'delivery_deadline'),
      params.quoteRequest.deliveryDeadlineDatetime ?? null,
    );

    const orderedVolume =
      params.quoteRequest.requestedVolumeLiters ?? null;
    if (orderedVolume === null || Number.isNaN(orderedVolume)) {
      throw new BadRequestException(
        'No se puede tramitar un pedido sin cantidad.',
      );
    }

    const orderId = randomUUID();
    const orderNumber = this.buildOrderNumber();

    const order = await this.ordersRepository.createOrder({
      id: orderId,
      orderNumber,
      clientId,
      quoteId: null,
      productId,
      categoryId,
      originLoadingPointId: originPoint.id,
      destinationUnloadingPointId: destinationPoint.id,
      requestedPickupDatetime,
      requestedDeliveryDatetime,
      confirmedPickupDatetime: requestedPickupDatetime,
      confirmedDeliveryDatetime: requestedDeliveryDatetime,
      orderedVolumeLiters: orderedVolume,
      orderedWeightTn: params.quoteRequest.requestedWeightTn ?? null,
      serviceMode: 'road',
      orderStatus: 'closed',
      priorityLevel: null,
      clientReference:
        params.quoteRequest.externalReference ??
        params.quoteRequest.conversationSessionId ??
        null,
      internalNotes: `Pedido cerrado desde asistente IA. QuoteRequest ${params.quoteRequest.id}.`,
    });

    const quoteOptionId = params.topOption?.id ?? null;
    const draftPayload: Record<string, unknown> = {
      orderId: order.id,
      orderNumber: order.orderNumber,
      quoteRequestId: params.quoteRequest.id,
      quoteOptionId,
      clientId,
      productId,
      categoryId,
      originLoadingPointId: originPoint.id,
      destinationUnloadingPointId: destinationPoint.id,
      requestedPickupDatetime: requestedPickupDatetime?.toISOString() ?? null,
      requestedDeliveryDatetime: requestedDeliveryDatetime?.toISOString() ?? null,
      orderedVolumeLiters: orderedVolume,
      orderedWeightTn: params.quoteRequest.requestedWeightTn ?? null,
      serviceMode: 'road',
      orderStatus: 'closed',
    };

    if (closedDraft) {
      await this.ordersRepository.updateDraftOrder(closedDraft.id, {
        status: 'closed',
        notes: 'Pedido cerrado desde asistente.',
        draftPayloadJson: draftPayload,
      });
    } else {
      await this.ordersRepository.createDraftOrder({
        quoteRequestId: params.quoteRequest.id,
        quoteOptionId,
        status: 'closed',
        notes: 'Pedido cerrado desde asistente.',
        draftPayloadJson: draftPayload,
      });
    }

    await this.quoteService.updateQuoteRequestData(params.quoteRequest.id, {
      wizardStatus: 'completed',
      clientId,
    });

    return { order, created: true };
  }

  private safeParseJson(value: string | null) {
    if (!value) {
      return null;
    }

    try {
      return JSON.parse(value) as Record<string, unknown>;
    } catch {
      return null;
    }
  }

  private normalizeCoord(value: unknown): number | null {
    if (typeof value === 'number' && Number.isFinite(value)) {
      return value;
    }
    if (typeof value === 'string') {
      const parsed = Number(value.replace(',', '.'));
      return Number.isFinite(parsed) ? parsed : null;
    }
    return null;
  }

  private getWizardCoordinates(
    wizardStates: SessionStepStateEntity[],
    stepCodes: string[],
  ): { latitude: number; longitude: number } | null {
    for (const code of stepCodes) {
      const state = wizardStates.find(
        (item) => item.wizardStep?.code === code,
      );
      const payload = this.safeParseJson(state?.normalizedValueJson ?? null);
      if (!payload) {
        continue;
      }

      const lat = this.normalizeCoord(
        payload.latitude ?? payload.lat ?? payload.originLat ?? payload.destinationLat,
      );
      const lon = this.normalizeCoord(
        payload.longitude ?? payload.lon ?? payload.originLon ?? payload.destinationLon,
      );

      if (
        lat !== null &&
        lon !== null &&
        lat >= 36.0 &&
        lat <= 43.8 &&
        lon >= -9.5 &&
        lon <= 3.3
      ) {
        return { latitude: lat, longitude: lon };
      }
    }

    return null;
  }

  private async resolveClientId(
    userId: string,
    quoteRequest: QuoteRequestEntity,
  ) {
    if (quoteRequest.clientId) {
      return quoteRequest.clientId;
    }

    const user = await this.usersService.findById(userId);
    if (user.clientId) {
      await this.quoteService.updateQuoteRequestData(quoteRequest.id, {
        clientId: user.clientId,
      });
      return user.clientId;
    }

    const clientCode = `CLI-${user.id.slice(0, 8).toUpperCase()}`;
    const legalName = user.fullName?.trim() || user.email;

    const client = this.clientRepository.create({
      id: randomUUID(),
      code: clientCode,
      legalName,
      tradeName: legalName,
      vatNumber: null,
      countryCode: 'ES',
      status: 'active',
      clientType: user.clientType ?? 'fidelizado',
      primarySector: 'general',
      slaTier: null,
      paymentTermsDays: null,
      preferredLanguage: 'es',
      notes: `Cliente creado automáticamente para el usuario ${user.email}.`,
    });

    const saved = await this.clientRepository.save(client);
    await this.usersService.assignClientId(user.id, saved.id);
    await this.quoteService.updateQuoteRequestData(quoteRequest.id, {
      clientId: saved.id,
    });

    return saved.id;
  }

  private async resolveProductAndCategory(
    quoteRequest: QuoteRequestEntity,
    topOption: QuoteOptionEntity | null,
  ) {
    let productId = quoteRequest.requestedProductId ?? null;
    let categoryId = quoteRequest.requestedCategoryId ?? null;

    if (topOption) {
      const reasoning = this.safeParseJson(topOption.reasoningJson);
      if (reasoning) {
        if (typeof reasoning.productId === 'string' && !productId) {
          productId = reasoning.productId;
        }
        if (typeof reasoning.categoryId === 'string' && !categoryId) {
          categoryId = reasoning.categoryId;
        }
      }
    }

    if ((!productId || !categoryId) && quoteRequest.requestedProductText) {
      const product = await this.catalogRepository.findProductByText(
        quoteRequest.requestedProductText,
      );
      if (!productId) {
        productId = product?.id ?? null;
      }
      if (!categoryId) {
        categoryId = product?.categoryId ?? null;
      }
    }

    if (!productId || !categoryId) {
      throw new BadRequestException(
        'No se ha podido resolver el producto o la categoría para cerrar el pedido.',
      );
    }

    return { productId, categoryId };
  }

  private async resolveLoadingPoint(params: {
    quoteRequest: QuoteRequestEntity;
    wizardStates: SessionStepStateEntity[];
    clientId: string;
  }) {
    if (params.quoteRequest.originLoadingPointId) {
      const existing = await this.catalogRepository.findLoadingPointById(
        params.quoteRequest.originLoadingPointId,
      );
      if (existing) {
        return existing;
      }
    }

    const addressText = this.getWizardValue(
      params.wizardStates,
      'origin_address',
    );
    const searchText = addressText ?? params.quoteRequest.originText ?? '';
    if (searchText) {
      const existing =
        await this.catalogRepository.findLoadingPointByText(searchText);
      if (existing) {
        return existing;
      }
    }

    const wizardCoords = this.getWizardCoordinates(params.wizardStates, [
      'origin_address',
      'origin',
    ]);

    const location = this.buildLocationData({
      cityHint: params.quoteRequest.originText,
      addressText,
    });
    if (wizardCoords) {
      location.latitude = wizardCoords.latitude;
      location.longitude = wizardCoords.longitude;
    }

    return this.catalogRepository.createLoadingPoint({
      code: this.buildPointCode('ORIG'),
      name: `Origen ${location.city}`,
      countryCode: 'ES',
      city: location.city,
      addressLine1: location.addressLine1,
      postalCode: location.postalCode,
      latitude: location.latitude,
      longitude: location.longitude,
      clientId: params.clientId,
      notes: 'Punto creado automáticamente desde asistente.',
    });
  }

  private async resolveUnloadingPoint(params: {
    quoteRequest: QuoteRequestEntity;
    wizardStates: SessionStepStateEntity[];
    clientId: string;
  }) {
    if (params.quoteRequest.destinationUnloadingPointId) {
      const existing = await this.catalogRepository.findUnloadingPointById(
        params.quoteRequest.destinationUnloadingPointId,
      );
      if (existing) {
        return existing;
      }
    }

    const addressText = this.getWizardValue(
      params.wizardStates,
      'destination_address',
    );
    const searchText = addressText ?? params.quoteRequest.destinationText ?? '';
    if (searchText) {
      const existing =
        await this.catalogRepository.findUnloadingPointByText(searchText);
      if (existing) {
        return existing;
      }
    }

    const wizardCoords = this.getWizardCoordinates(params.wizardStates, [
      'destination_address',
      'destination',
    ]);

    const location = this.buildLocationData({
      cityHint: params.quoteRequest.destinationText,
      addressText,
    });
    if (wizardCoords) {
      location.latitude = wizardCoords.latitude;
      location.longitude = wizardCoords.longitude;
    }

    return this.catalogRepository.createUnloadingPoint({
      code: this.buildPointCode('DEST'),
      name: `Destino ${location.city}`,
      countryCode: 'ES',
      city: location.city,
      addressLine1: location.addressLine1,
      postalCode: location.postalCode,
      latitude: location.latitude,
      longitude: location.longitude,
      clientId: params.clientId,
      notes: 'Punto creado automáticamente desde asistente.',
    });
  }

  private getWizardValue(
    wizardStates: SessionStepStateEntity[],
    stepCode: string,
  ) {
    return (
      wizardStates.find((state) => state.wizardStep?.code === stepCode)
        ?.rawValueText ?? null
    );
  }

  private extractPostalCode(text: string | null) {
    if (!text) {
      return null;
    }
    const match = text.match(/\b(\d{4,6})\b/);
    return match ? match[1] : null;
  }

  private buildLocationData(params: {
    cityHint: string | null;
    addressText: string | null;
  }) {
    const postalCode =
      this.extractPostalCode(params.addressText) ??
      this.extractPostalCode(params.cityHint);
    const addressLine1 =
      params.addressText?.trim() ||
      params.cityHint?.trim() ||
      'Dirección pendiente';

    const citySource =
      params.cityHint?.trim() || params.addressText?.trim() || 'Ubicación';
    const cityCandidate = citySource.includes(',')
      ? citySource.split(',').at(-1)?.trim() || citySource
      : citySource;
    const city = cityCandidate
      .replace(/\b\d{4,6}\b/g, '')
      .replace(/[,]/g, ' ')
      .trim()
      .replace(/\s+/g, ' ');

    const coords = buildDecorativeCoordinates(
      `${addressLine1}|${city}|${postalCode ?? ''}`,
    );

    return {
      city: city.length > 0 ? city : 'Ubicación',
      postalCode,
      addressLine1,
      latitude: coords?.latitude ?? null,
      longitude: coords?.longitude ?? null,
    };
  }

  private resolveDateTime(
    value: string | Date | null | undefined,
    fallback: string | Date | null | undefined,
  ): Date | null {
    const parsed = this.parseDate(value);
    if (parsed) {
      return parsed;
    }
    return this.parseDate(fallback);
  }

  private parseDate(value: string | Date | null | undefined): Date | null {
    if (!value) {
      return null;
    }

    if (value instanceof Date) {
      return Number.isNaN(value.getTime()) ? null : value;
    }

    const trimmed = value.trim();
    if (!trimmed) {
      return null;
    }

    const dateOnlyMatch = trimmed.match(/^(\d{4})-(\d{2})-(\d{2})$/);
    if (dateOnlyMatch) {
      return new Date(`${trimmed}T00:00:00`);
    }

    const parsed = new Date(trimmed);
    return Number.isNaN(parsed.getTime()) ? null : parsed;
  }

  private buildPointCode(prefix: string) {
    const suffix = randomUUID().slice(0, 6).toUpperCase();
    return `${prefix}-${suffix}`;
  }

  private buildOrderNumber() {
    const now = new Date();
    const ymd = now.toISOString().slice(0, 10).replace(/-/g, '');
    const suffix = Math.random().toString(36).slice(2, 6).toUpperCase();
    return `ORD-${ymd}-${suffix}`;
  }
}
