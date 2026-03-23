import { Injectable } from '@nestjs/common';
import { CatalogRepository } from '../../catalog/repositories/catalog.repository';
import { QuoteRequestEntity } from '../../quote/entities/quote-request.entity';

@Injectable()
export class CompatibilityRulesService {
  constructor(private readonly catalogRepository: CatalogRepository) {}

  private isRuleActiveForDate(
    rule: {
      isActive: boolean;
      validFrom: string | null;
      validTo: string | null;
    },
    date: string | null,
  ) {
    if (!rule.isActive) {
      return false;
    }

    if (!date) {
      return true;
    }

    if (rule.validFrom && rule.validFrom > date) {
      return false;
    }

    if (rule.validTo && rule.validTo < date) {
      return false;
    }

    return true;
  }

  private resolveCompatibilityRule<
    T extends {
      previousProductId: string | null;
      nextProductId: string | null;
      previousCategoryId: string | null;
      nextCategoryId: string | null;
    },
  >(
    rules: T[],
    params: {
      previousProductId: string | null;
      previousCategoryId: string | null;
      nextProductId: string;
      nextCategoryId: string;
    },
  ) {
    let bestRule: T | null = null;
    let bestScore = -1;

    for (const rule of rules) {
      if (
        rule.previousProductId &&
        rule.previousProductId !== params.previousProductId
      ) {
        continue;
      }

      if (
        rule.previousCategoryId &&
        rule.previousCategoryId !== params.previousCategoryId
      ) {
        continue;
      }

      if (rule.nextProductId && rule.nextProductId !== params.nextProductId) {
        continue;
      }

      if (
        rule.nextCategoryId &&
        rule.nextCategoryId !== params.nextCategoryId
      ) {
        continue;
      }

      const score =
        (rule.previousProductId ? 4 : rule.previousCategoryId ? 2 : 0) +
        (rule.nextProductId ? 4 : rule.nextCategoryId ? 2 : 0);

      if (score > bestScore) {
        bestScore = score;
        bestRule = rule;
      }
    }

    return bestRule;
  }

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

    let filteredTanks = candidateTanks.filter((tank) => {
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

    const compatibilityRules =
      await this.catalogRepository.findProductCompatibilityRules();

    const activeRules = compatibilityRules.filter((rule) =>
      this.isRuleActiveForDate(rule, requestedDate),
    );

    if (activeRules.length === 0) {
      results.push({
        ruleCode: 'COMPATIBILITY_RULES_EMPTY',
        severity: 'warning',
        passed: true,
        message:
          'No hay reglas de compatibilidad activas; se mantiene revisión operativa manual.',
      });
    } else {
      const lastProductIds = filteredTanks
        .map((tank) => tank.lastProductId)
        .filter((id): id is string => Boolean(id));

      const productsById = new Map(
        (await this.catalogRepository.findProductsByIds([
          ...new Set([...lastProductIds, product.id]),
        ])).map((item) => [item.id, item]),
      );

      const compatibilitySummary = {
        compatibleCount: 0,
        incompatibleCount: 0,
        reviewCount: 0,
        missingHistoryCount: 0,
        missingRuleCount: 0,
        cleaningCount: 0,
        cleaningTypes: new Map<string, number>(),
        filterMissingCount: 0,
        resetRequiredCount: 0,
      };

      const compatibleTanks: typeof filteredTanks = [];

      for (const tank of filteredTanks) {
        const lastProductId = tank.lastProductId;
        if (!lastProductId) {
          compatibilitySummary.reviewCount += 1;
          compatibilitySummary.missingHistoryCount += 1;
          compatibleTanks.push(tank);
          continue;
        }

        const previousProduct = productsById.get(lastProductId);
        if (!previousProduct) {
          compatibilitySummary.reviewCount += 1;
          compatibilitySummary.missingHistoryCount += 1;
          compatibleTanks.push(tank);
          continue;
        }

        const rule = this.resolveCompatibilityRule(activeRules, {
          previousProductId: previousProduct.id,
          previousCategoryId: previousProduct.categoryId,
          nextProductId: product.id,
          nextCategoryId: product.categoryId,
        });

        if (!rule) {
          compatibilitySummary.reviewCount += 1;
          compatibilitySummary.missingRuleCount += 1;
          compatibleTanks.push(tank);
          continue;
        }

        if (rule.bacteriologicalFilterRequired && !tank.bacteriologicalFilter) {
          compatibilitySummary.incompatibleCount += 1;
          compatibilitySummary.filterMissingCount += 1;
          continue;
        }

        const status = rule.compatibilityStatus
          ? rule.compatibilityStatus.toLowerCase()
          : 'review';

        if (status === 'incompatible') {
          compatibilitySummary.incompatibleCount += 1;
          continue;
        }

        if (status === 'review') {
          compatibilitySummary.reviewCount += 1;
        } else {
          compatibilitySummary.compatibleCount += 1;
        }

        if (rule.cleaningRequired) {
          compatibilitySummary.cleaningCount += 1;
          const cleaningType = rule.requiredCleaningType ?? 'STANDARD';
          compatibilitySummary.cleaningTypes.set(
            cleaningType,
            (compatibilitySummary.cleaningTypes.get(cleaningType) ?? 0) + 1,
          );
        }

        if (rule.coolingOrHeatingResetRequired) {
          compatibilitySummary.resetRequiredCount += 1;
        }

        compatibleTanks.push(tank);
      }

      filteredTanks = compatibleTanks;

      if (compatibilitySummary.incompatibleCount > 0) {
        results.push({
          ruleCode: 'COMPATIBILITY_RULES_INCOMPATIBLE',
          severity: 'warning',
          passed: true,
          message: `Se descartaron ${compatibilitySummary.incompatibleCount} tanques por incompatibilidad con el último producto.`,
        });
      }

      if (compatibilitySummary.filterMissingCount > 0) {
        results.push({
          ruleCode: 'COMPATIBILITY_RULES_FILTER_MISSING',
          severity: 'warning',
          passed: true,
          message: `${compatibilitySummary.filterMissingCount} tanques no cumplen el filtro bacteriológico requerido para la transición.`,
        });
      }

      if (compatibilitySummary.missingHistoryCount > 0) {
        results.push({
          ruleCode: 'COMPATIBILITY_RULES_HISTORY_MISSING',
          severity: 'warning',
          passed: true,
          message: `${compatibilitySummary.missingHistoryCount} tanques no tienen histórico de producto y requieren revisión manual.`,
        });
      }

      if (compatibilitySummary.missingRuleCount > 0) {
        results.push({
          ruleCode: 'COMPATIBILITY_RULES_NOT_FOUND',
          severity: 'warning',
          passed: true,
          message: `${compatibilitySummary.missingRuleCount} tanques no tienen una regla explícita y quedan en revisión.`,
        });
      }

      if (compatibilitySummary.cleaningCount > 0) {
        const cleaningNotes = Array.from(
          compatibilitySummary.cleaningTypes.entries(),
        )
          .map(([type, count]) => `${count} con limpieza ${type}`)
          .join(', ');
        results.push({
          ruleCode: 'COMPATIBILITY_RULES_CLEANING',
          severity: 'info',
          passed: true,
          message: `Se requieren limpiezas para ${compatibilitySummary.cleaningCount} tanques (${cleaningNotes}).`,
        });
      }

      if (compatibilitySummary.resetRequiredCount > 0) {
        results.push({
          ruleCode: 'COMPATIBILITY_RULES_RESET',
          severity: 'info',
          passed: true,
          message: `${compatibilitySummary.resetRequiredCount} transiciones requieren reset térmico del tanque.`,
        });
      }

      if (filteredTanks.length === 0) {
        results.push({
          ruleCode: 'COMPATIBILITY_RULES_NO_TANKS',
          severity: 'error',
          passed: false,
          message:
            'Tras aplicar reglas de compatibilidad, no quedan tanques aptos para el producto solicitado.',
        });

        return results;
      }
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
      message: `Se han encontrado ${filteredTanks.length} tanques compatibles para el producto tras aplicar reglas de compatibilidad.`,
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
