import { Injectable, NotFoundException } from '@nestjs/common';
import { ValidationStatus } from '../../common/enums/transport/validation-status.enum';
import { QuoteService } from '../quote/quote.service';
import { ValidateQuoteDto } from './dto/validate-quote.dto';
import { RulesRepository } from './repositories/rules.repository';
import { CompatibilityRulesService } from './services/compatibility-rules.service';

@Injectable()
export class RulesService {
  constructor(
    private readonly quoteService: QuoteService,
    private readonly rulesRepository: RulesRepository,
    private readonly compatibilityRulesService: CompatibilityRulesService,
  ) {}

  async validateQuoteRequest(quoteRequestId: string, dto: ValidateQuoteDto) {
    const quoteResponse =
      await this.quoteService.getQuoteRequestById(quoteRequestId);
    const quoteRequest = quoteResponse.quoteRequest;

    if (!quoteRequest) {
      throw new NotFoundException(
        `No existe ninguna solicitud de presupuesto con id ${quoteRequestId}`,
      );
    }

    if (dto.clearPreviousResults) {
      await this.rulesRepository.deleteValidationResultsByQuoteRequestId(
        quoteRequestId,
      );
    }

    const results = [
      {
        ruleCode: 'PRODUCT_REQUIRED',
        severity: 'error',
        validationStatus:
          quoteRequest.requestedProductText &&
          quoteRequest.requestedProductText !== 'Pendiente'
            ? 'passed'
            : 'failed',
        message:
          quoteRequest.requestedProductText &&
          quoteRequest.requestedProductText !== 'Pendiente'
            ? 'Producto informado correctamente.'
            : 'Falta el producto.',
      },
      {
        ruleCode: 'QUANTITY_REQUIRED',
        severity: 'error',
        validationStatus: quoteRequest.requestedVolumeLiters
          ? 'passed'
          : 'failed',
        message: quoteRequest.requestedVolumeLiters
          ? 'Cantidad informada correctamente.'
          : 'Falta la cantidad.',
      },
      {
        ruleCode: 'ORIGIN_REQUIRED',
        severity: 'error',
        validationStatus: quoteRequest.originText ? 'passed' : 'failed',
        message: quoteRequest.originText
          ? 'Origen informado correctamente.'
          : 'Falta el origen.',
      },
      {
        ruleCode: 'DESTINATION_REQUIRED',
        severity: 'error',
        validationStatus: quoteRequest.destinationText ? 'passed' : 'failed',
        message: quoteRequest.destinationText
          ? 'Destino informado correctamente.'
          : 'Falta el destino.',
      },
      {
        ruleCode: 'LOAD_DATE_REQUIRED',
        severity: 'error',
        validationStatus: quoteRequest.requestedLoadDate ? 'passed' : 'failed',
        message: quoteRequest.requestedLoadDate
          ? 'Fecha de carga informada correctamente.'
          : 'Falta la fecha solicitada.',
      },
      {
        ruleCode: 'DELIVERY_DEADLINE_REQUIRED',
        severity: 'error',
        validationStatus: quoteRequest.deliveryDeadlineDatetime
          ? 'passed'
          : 'failed',
        message: quoteRequest.deliveryDeadlineDatetime
          ? 'Límite de entrega informado correctamente.'
          : 'Falta el límite de entrega.',
      },
    ];

    const compatibilityResults =
      await this.compatibilityRulesService.evaluate(quoteRequest);

    for (const item of compatibilityResults) {
      results.push({
        ruleCode: item.ruleCode,
        severity: item.severity,
        validationStatus: item.passed
          ? item.severity === 'warning'
            ? 'warning'
            : 'passed'
          : 'failed',
        message: item.message,
      });
    }

    for (const result of results) {
      await this.rulesRepository.createValidationResult({
        quoteRequestId,
        validationScope: 'quote_request',
        ruleCode: result.ruleCode,
        severity: result.severity,
        validationStatus: result.validationStatus,
        message: result.message,
        blocking: result.validationStatus === 'failed',
      });
    }

    const hasFailed = results.some(
      (result) => result.validationStatus === 'failed',
    );

    await this.quoteService.updateQuoteRequestValidationStatus(
      quoteRequestId,
      hasFailed ? ValidationStatus.FAILED : ValidationStatus.PASSED,
    );

    return this.getValidationSummary(quoteRequestId);
  }

  async getValidationSummary(quoteRequestId: string) {
    const quoteResponse =
      await this.quoteService.getQuoteRequestById(quoteRequestId);
    const results = quoteResponse.validationResults;

    return {
      quoteRequestId,
      total: results.length,
      passed: results.filter((item) => item.validationStatus === 'passed')
        .length,
      failed: results.filter((item) => item.validationStatus === 'failed')
        .length,
      warnings: results.filter((item) => item.validationStatus === 'warning')
        .length,
      results,
    };
  }
}
