import { Injectable } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { CatalogRepository } from '../../catalog/repositories/catalog.repository';
import { RouteSuggestionService } from '../../catalog/services/route-suggestion.service';
import { QuoteRequestEntity } from '../../quote/entities/quote-request.entity';

@Injectable()
export class PricingEngineService {
  private readonly fallbackSpeedKmh: number;
  private readonly llmRouteMinConfidence: number;

  constructor(
    private readonly catalogRepository: CatalogRepository,
    private readonly routeSuggestionService: RouteSuggestionService,
    private readonly configService: ConfigService,
  ) {
    const configured = this.toNumber(
      this.configService.get<string>('PRICING_FALLBACK_SPEED_KMH'),
    );
    this.fallbackSpeedKmh = configured && configured > 0 ? configured : 70;

    const configuredMinConfidence = this.toNumber(
      this.configService.get<string>('LLM_ROUTE_MIN_CONFIDENCE'),
    );
    if (
      typeof configuredMinConfidence === 'number' &&
      configuredMinConfidence >= 0
    ) {
      this.llmRouteMinConfidence = Math.min(1, configuredMinConfidence);
    } else {
      this.llmRouteMinConfidence = 0.55;
    }
  }

  private parseAllowedVehicleTypes(value: string | null | undefined) {
    if (!value) {
      return [];
    }

    return value
      .split(',')
      .map((item) => item.trim().toUpperCase())
      .filter((item) => item.length > 0);
  }

  private toNumber(value: number | string | null | undefined) {
    if (value === null || value === undefined) {
      return null;
    }

    const parsed = Number(value);
    return Number.isFinite(parsed) ? parsed : null;
  }

  private haversineDistanceKm(
    originLat: number,
    originLon: number,
    destinationLat: number,
    destinationLon: number,
  ) {
    const toRadians = (deg: number) => (deg * Math.PI) / 180;
    const earthRadiusKm = 6371;

    const dLat = toRadians(destinationLat - originLat);
    const dLon = toRadians(destinationLon - originLon);

    const lat1 = toRadians(originLat);
    const lat2 = toRadians(destinationLat);

    const a =
      Math.sin(dLat / 2) * Math.sin(dLat / 2) +
      Math.sin(dLon / 2) *
        Math.sin(dLon / 2) *
        Math.cos(lat1) *
        Math.cos(lat2);

    const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
    return earthRadiusKm * c;
  }

  async buildOption(quoteRequest: QuoteRequestEntity) {
    const liters = Number(quoteRequest.requestedVolumeLiters ?? 0);

    const estimatedCost =
      liters > 0 ? Number((liters * 0.12 + 250).toFixed(2)) : 300;

    const product = quoteRequest.requestedProductText
      ? await this.catalogRepository.findProductByText(
          quoteRequest.requestedProductText,
        )
      : null;

    const requestedDate = quoteRequest.requestedLoadDate ?? null;

    const authorizedTanks = product
      ? await this.catalogRepository.findAuthorizedTanks({
          productId: product.id,
          categoryId: product.categoryId,
          date: requestedDate,
        })
      : [];

    const compatibleTanks = product
      ? authorizedTanks.filter((tank) => {
          if (product.needsHeating && !tank.heatingSystem) {
            return false;
          }

          if (product.needsCooling && !tank.coolingSystem) {
            return false;
          }

          if (
            (product.temperatureMinC !== null ||
              product.temperatureMaxC !== null) &&
            !tank.temperatureControl
          ) {
            return false;
          }

          if (
            product.needsBacteriologicalFilter &&
            !tank.bacteriologicalFilter
          ) {
            return false;
          }

          return true;
        })
      : [];

    const originPoint = quoteRequest.originLoadingPointId
      ? await this.catalogRepository.findLoadingPointById(
          quoteRequest.originLoadingPointId,
        )
      : quoteRequest.originText
        ? await this.catalogRepository.findLoadingPointByText(
            quoteRequest.originText,
          )
        : null;

    const destinationPoint = quoteRequest.destinationUnloadingPointId
      ? await this.catalogRepository.findUnloadingPointById(
          quoteRequest.destinationUnloadingPointId,
        )
      : quoteRequest.destinationText
        ? await this.catalogRepository.findUnloadingPointByText(
            quoteRequest.destinationText,
          )
        : null;

    let route =
      originPoint && destinationPoint
        ? await this.catalogRepository.findRouteByPoints(
            originPoint.id,
            destinationPoint.id,
          )
        : null;

    let llmRouteSuggestion: {
      routeCode: string | null;
      confidence: number | null;
      rationale: string | null;
      alternativeRouteCodes: string[];
    } | null = null;
    let usedLlmRoute = false;
    let llmSuggestedRouteId: string | null = null;
    let llmRouteAccepted: boolean | null = null;

    if (!route && quoteRequest.originText && quoteRequest.destinationText) {
      const suggestion = await this.routeSuggestionService.suggestRoute({
        originText: quoteRequest.originText,
        destinationText: quoteRequest.destinationText,
        userId: null,
      });

      llmRouteSuggestion = suggestion.suggestion;
      llmSuggestedRouteId = suggestion.route?.id ?? null;

      if (llmRouteSuggestion) {
        const confidence = llmRouteSuggestion.confidence;
        const meetsThreshold =
          typeof confidence === 'number'
            ? confidence >= this.llmRouteMinConfidence
            : false;

        if (suggestion.route && meetsThreshold) {
          route = suggestion.route;
          usedLlmRoute = true;
          llmRouteAccepted = true;
        } else {
          llmRouteAccepted = false;
        }
      }
    }

    let routeAssignedVehicleIds = new Set<string>();
    let routeAssignmentsCount = 0;

    if (route) {
      const routeLinks = await this.catalogRepository.findVehicleRouteLinks({
        routeId: route.id,
        date: requestedDate,
      });
      routeAssignmentsCount = routeLinks.length;
      if (routeLinks.length > 0) {
        routeAssignedVehicleIds = new Set(
          routeLinks.map((link) => link.vehicleId),
        );
      }
    }

    let estimatedKm = route ? Number(route.standardDistanceKm) : null;
    let estimatedTransitHours = route
      ? Number((route.standardDurationMinutes / 60).toFixed(2))
      : null;
    let usedFallbackRoute = false;

    if (!route && originPoint && destinationPoint) {
      const originLat = this.toNumber(originPoint.latitude);
      const originLon = this.toNumber(originPoint.longitude);
      const destinationLat = this.toNumber(destinationPoint.latitude);
      const destinationLon = this.toNumber(destinationPoint.longitude);

      if (
        originLat !== null &&
        originLon !== null &&
        destinationLat !== null &&
        destinationLon !== null
      ) {
        const distanceKm = this.haversineDistanceKm(
          originLat,
          originLon,
          destinationLat,
          destinationLon,
        );
        estimatedKm = Number(distanceKm.toFixed(2));
        estimatedTransitHours = Number(
          (distanceKm / this.fallbackSpeedKmh).toFixed(2),
        );
        usedFallbackRoute = true;
      }
    }

    let vehicles = await this.catalogRepository.findVehicles(true);
    const availability =
      requestedDate !== null
        ? await this.catalogRepository.findVehicleAvailabilityByDate(
            requestedDate,
          )
        : [];

    if (requestedDate && availability.length > 0) {
      const availableVehicleIds = new Set(
        availability.map((item) => item.vehicleId),
      );

      vehicles = vehicles.filter((vehicle) => availableVehicleIds.has(vehicle.id));

      if (estimatedKm !== null) {
        const kmLimitByVehicle = new Map(
          availability
            .filter((item) => typeof item.plannedKmLimit === 'number')
            .map((item) => [item.vehicleId, Number(item.plannedKmLimit)]),
        );

        vehicles = vehicles.filter((vehicle) => {
          const limit = kmLimitByVehicle.get(vehicle.id);
          return typeof limit === 'number' ? limit >= estimatedKm : true;
        });
      }
    }
    if (requestedDate && availability.length === 0) {
      vehicles = [];
    }

    const originAllowed = this.parseAllowedVehicleTypes(
      originPoint?.allowedVehicleTypes ?? null,
    );
    if (originAllowed.length > 0) {
      vehicles = vehicles.filter((vehicle) =>
        originAllowed.includes(vehicle.vehicleTypeCode.toUpperCase()),
      );
    }

    const destinationAllowed = this.parseAllowedVehicleTypes(
      destinationPoint?.allowedVehicleTypes ?? null,
    );
    if (destinationAllowed.length > 0) {
      vehicles = vehicles.filter((vehicle) =>
        destinationAllowed.includes(vehicle.vehicleTypeCode.toUpperCase()),
      );
    }

    let selectedTankId: string | null = null;
    let tanksByVehicle: Map<string, string[]> | null = null;
    if (compatibleTanks.length > 0) {
      const vehicleTankLinks = await this.catalogRepository.findVehicleTankLinks({
        tankIds: compatibleTanks.map((tank) => tank.id),
        date: requestedDate,
      });

      if (vehicleTankLinks.length > 0) {
        const tanksByVehicleLocal = new Map<string, string[]>();
        for (const link of vehicleTankLinks) {
          const list = tanksByVehicleLocal.get(link.vehicleId) ?? [];
          list.push(link.tankId);
          tanksByVehicleLocal.set(link.vehicleId, list);
        }

        vehicles = vehicles.filter((vehicle) =>
          tanksByVehicleLocal.has(vehicle.id),
        );
        tanksByVehicle = tanksByVehicleLocal;
      } else {
        vehicles = [];
      }
    }

    let routePreferenceApplied = false;
    let routeAssignedVehiclesInPool = 0;
    if (routeAssignedVehicleIds.size > 0 && vehicles.length > 0) {
      const preferred: typeof vehicles = [];
      const remaining: typeof vehicles = [];
      for (const vehicle of vehicles) {
        if (routeAssignedVehicleIds.has(vehicle.id)) {
          preferred.push(vehicle);
        } else {
          remaining.push(vehicle);
        }
      }
      routeAssignedVehiclesInPool = preferred.length;
      if (preferred.length > 0) {
        vehicles = [...preferred, ...remaining];
        routePreferenceApplied = true;
      }
    }

    const selectedVehicle = vehicles[0] ?? null;
    if (selectedVehicle && tanksByVehicle) {
      selectedTankId = tanksByVehicle.get(selectedVehicle.id)?.[0] ?? null;
    }
    if (selectedVehicle && selectedTankId === null && compatibleTanks.length > 0) {
      const vehicleTankLinks = await this.catalogRepository.findVehicleTankLinks({
        vehicleIds: [selectedVehicle.id],
        date: requestedDate,
      });
      selectedTankId = vehicleTankLinks[0]?.tankId ?? null;
    }

    const hasOriginPoint = Boolean(originPoint);
    const hasDestinationPoint = Boolean(destinationPoint);
    const hasRoute = Boolean(route || usedFallbackRoute);
    const hasAvailability = requestedDate ? availability.length > 0 : true;

    const isFeasible =
      Boolean(product) &&
      compatibleTanks.length > 0 &&
      selectedVehicle !== null &&
      selectedTankId !== null &&
      hasOriginPoint &&
      hasDestinationPoint &&
      hasRoute &&
      estimatedTransitHours !== null &&
      hasAvailability;

    const notes: string[] = [];
    if (!originPoint && quoteRequest.originText) {
      notes.push('Origen no normalizado en catálogo.');
    }
    if (!destinationPoint && quoteRequest.destinationText) {
      notes.push('Destino no normalizado en catálogo.');
    }
    if (!route && originPoint && destinationPoint && usedFallbackRoute) {
      notes.push(
        'No se encontró ruta estándar; tiempo estimado con cálculo aproximado.',
      );
    }
    if (!route && originPoint && destinationPoint && !usedFallbackRoute) {
      notes.push(
        'No se encontró ruta estándar ni coordenadas para estimar el tiempo.',
      );
    }
    if (usedLlmRoute && route) {
      const confidence = llmRouteSuggestion?.confidence;
      notes.push(
        `Ruta sugerida por IA: ${route.code}${
          typeof confidence === 'number'
            ? ` (confianza ${confidence.toFixed(2)})`
            : ''
        }.`,
      );
    } else if (llmRouteSuggestion?.routeCode) {
      const confidence = llmRouteSuggestion?.confidence;
      notes.push(
        `Ruta sugerida por IA (${llmRouteSuggestion.routeCode}) no aplicada${
          typeof confidence === 'number'
            ? ` (confianza ${confidence.toFixed(2)} < mínimo ${this.llmRouteMinConfidence.toFixed(
                2,
              )})`
            : ''
        }.`,
      );
    }
    if (requestedDate && availability.length === 0) {
      notes.push('No hay disponibilidad registrada para la fecha solicitada.');
    }
    if (selectedVehicle === null) {
      notes.push('No hay vehículos disponibles para la fecha solicitada.');
    }
    if (product && compatibleTanks.length === 0) {
      notes.push('No hay tanques compatibles con el producto.');
    }
    if (compatibleTanks.length > 0 && selectedTankId === null) {
      notes.push(
        'No hay relación vehículo-tanque para los tanques compatibles; no se puede garantizar aptitud.',
      );
    }

    const selectedVehicleId = selectedTankId ? selectedVehicle?.id ?? null : null;
    const selectedVehicleCode = selectedTankId
      ? selectedVehicle?.code ?? null
      : null;

    return {
      vehicleTypeId: selectedVehicleId,
      cleaningProtocolId: null,
      estimatedCost,
      estimatedTransitHours,
      isFeasible,
      recommendationScore: isFeasible ? 90 : 40,
      routeSuggestion: {
        suggestedRouteId: llmSuggestedRouteId,
        suggestedRouteCode: llmRouteSuggestion?.routeCode ?? null,
        suggestedRouteConfidence: llmRouteSuggestion?.confidence ?? null,
        suggestedRouteRationale: llmRouteSuggestion?.rationale ?? null,
        suggestedRouteAccepted: llmRouteAccepted,
      },
      reasoningJson: {
        formula: 'base + liters * 0.12',
        productId: product?.id ?? null,
        categoryId: product?.categoryId ?? null,
        productCategoryName: product?.category?.name ?? null,
        productCategoryCode: product?.category?.code ?? null,
        compatibleTanks: compatibleTanks.length,
        availableVehicles: vehicles.length,
        routeId: route?.id ?? null,
        distanceKm: estimatedKm,
        selectedVehicleId,
        selectedVehicleCode,
        selectedTankId,
        usedFallbackRoute,
        fallbackSpeedKmh: usedFallbackRoute ? this.fallbackSpeedKmh : null,
        hasOriginPoint,
        hasDestinationPoint,
        hasRoute,
        hasAvailability,
        routeAssignmentsCount: routeAssignmentsCount || 0,
        routeAssignedVehiclesInPool,
        routePreferenceApplied,
        llmSuggestedRouteCode: llmRouteSuggestion?.routeCode ?? null,
        llmSuggestedRouteId,
        llmSuggestedRouteConfidence: llmRouteSuggestion?.confidence ?? null,
        llmSuggestedRouteRationale: llmRouteSuggestion?.rationale ?? null,
        llmSuggestedRouteAccepted: llmRouteAccepted,
        llmSuggestedRouteMinConfidence: this.llmRouteMinConfidence,
        llmAlternativeRouteCodes:
          llmRouteSuggestion?.alternativeRouteCodes ?? [],
      },
      notes:
        notes.length > 0
          ? notes.join(' ')
          : 'Opción generada con catálogos y disponibilidad actual.',
    };
  }
}
