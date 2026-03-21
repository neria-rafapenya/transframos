import { Injectable } from '@nestjs/common';
import { QuoteRequestEntity } from '../../quote/entities/quote-request.entity';

@Injectable()
export class CleaningRulesService {
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
        ruleCode: 'CLEANING_PRODUCT_REQUIRED',
        severity: 'error',
        passed: false,
        message:
          'No se puede evaluar la limpieza porque falta el producto solicitado.',
      });

      return results;
    }

    results.push({
      ruleCode: 'CLEANING_PROTOCOL_CHECK',
      severity: 'info',
      passed: true,
      message:
        'La validación de limpieza simplificada no detecta incompatibilidades.',
    });

    return results;
  }
}
