import { Injectable } from '@nestjs/common';
import { CatalogRepository } from '../../catalog/repositories/catalog.repository';
import { QuoteRequestEntity } from '../../quote/entities/quote-request.entity';

@Injectable()
export class CompatibilityRulesService {
  constructor(private readonly catalogRepository: CatalogRepository) {}

  async evaluate(quoteRequest: QuoteRequestEntity) {
    const results: Array<{
      ruleCode: string;
      severity: string;
      passed: boolean;
      message: string;
    }> = [];

    if (
      !quoteRequest.requestedProductText ||
      quoteRequest.requestedProductText === 'Pendiente'
    ) {
      results.push({
        ruleCode: 'COMPATIBILITY_PRODUCT_REQUIRED',
        severity: 'error',
        passed: false,
        message:
          'No se puede evaluar la compatibilidad porque falta el producto.',
      });

      return results;
    }

    const product = await this.catalogRepository.findProductByText(
      quoteRequest.requestedProductText,
    );

    if (!product) {
      results.push({
        ruleCode: 'COMPATIBILITY_PRODUCT_NOT_FOUND',
        severity: 'error',
        passed: false,
        message:
          'No se ha podido normalizar el producto en catálogo para validar compatibilidad.',
      });

      return results;
    }

    const requestedDate = quoteRequest.requestedLoadDate ?? null;
    const candidateTanks = await this.catalogRepository.findAuthorizedTanks({
      productId: product.id,
      categoryId: product.categoryId,
      date: requestedDate,
    });

    if (candidateTanks.length === 0) {
      results.push({
        ruleCode: 'COMPATIBILITY_NO_AUTH_TANKS',
        severity: 'error',
        passed: false,
        message:
          'No hay tanques autorizados para este producto o categoría.',
      });

      return results;
    }

    const filteredTanks = candidateTanks.filter((tank) => {
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
    });

    if (filteredTanks.length === 0) {
      results.push({
        ruleCode: 'COMPATIBILITY_TANK_REQUIREMENTS_MISSING',
        severity: 'error',
        passed: false,
        message:
          'Hay tanques autorizados, pero ninguno cumple requisitos térmicos o de filtrado.',
      });

      return results;
    }

    const vehicleTankLinks = await this.catalogRepository.findVehicleTankLinks({
      tankIds: filteredTanks.map((tank) => tank.id),
      date: requestedDate,
    });

    if (vehicleTankLinks.length === 0) {
      results.push({
        ruleCode: 'COMPATIBILITY_NO_VEHICLE_TANK_LINK',
        severity: 'warning',
        passed: true,
        message:
          'No hay relación vehículo-tanque para los tanques compatibles; se requiere revisión operativa.',
      });
    }

    results.push({
      ruleCode: 'COMPATIBILITY_TANKS_AVAILABLE',
      severity: 'info',
      passed: true,
      message: `Se han encontrado ${filteredTanks.length} tanques compatibles para el producto.`,
    });

    results.push({
      ruleCode: 'COMPATIBILITY_REVIEW_REQUIRED',
      severity: 'warning',
      passed: true,
      message:
        'No hay validación directa de food grade a nivel de vehículo. Se recomienda revisión operativa si es crítico.',
    });

    return results;
  }
}
