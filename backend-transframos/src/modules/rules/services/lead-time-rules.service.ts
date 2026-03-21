import { Injectable } from '@nestjs/common';
import { QuoteRequestEntity } from '../../quote/entities/quote-request.entity';

@Injectable()
export class LeadTimeRulesService {
  async evaluate(quoteRequest: QuoteRequestEntity) {
    const results: Array<{
      ruleCode: string;
      severity: string;
      passed: boolean;
      message: string;
    }> = [];

    if (!quoteRequest.requestedLoadDate) {
      results.push({
        ruleCode: 'LEAD_TIME_LOAD_DATE_REQUIRED',
        severity: 'error',
        passed: false,
        message: 'Falta la fecha solicitada de carga.',
      });

      return results;
    }

    if (!quoteRequest.deliveryDeadlineDatetime) {
      results.push({
        ruleCode: 'LEAD_TIME_DEADLINE_REQUIRED',
        severity: 'error',
        passed: false,
        message: 'Falta el límite de entrega.',
      });

      return results;
    }

    const pickupAt = new Date(`${quoteRequest.requestedLoadDate}T00:00:00`);
    const deadlineAt = new Date(quoteRequest.deliveryDeadlineDatetime);

    if (
      Number.isNaN(pickupAt.getTime()) ||
      Number.isNaN(deadlineAt.getTime())
    ) {
      results.push({
        ruleCode: 'LEAD_TIME_INVALID_DATES',
        severity: 'error',
        passed: false,
        message: 'Las fechas informadas no son válidas.',
      });

      return results;
    }

    if (deadlineAt.getTime() < pickupAt.getTime()) {
      results.push({
        ruleCode: 'LEAD_TIME_ORDER_INVALID',
        severity: 'error',
        passed: false,
        message:
          'El límite de entrega no puede ser anterior a la fecha de carga.',
      });

      return results;
    }

    results.push({
      ruleCode: 'LEAD_TIME_ORDER_VALID',
      severity: 'info',
      passed: true,
      message:
        'La relación entre fecha de carga y límite de entrega es válida.',
    });

    return results;
  }
}
