import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { randomUUID } from 'crypto';
import { Repository } from 'typeorm';
import { ValidationResultEntity } from '../../quote/entities/validation-result.entity';

type CreateValidationResultParams = {
  sessionId?: string | null;
  quoteRequestId?: string | null;
  orderId?: string | null;
  validationScope: string;
  ruleCode: string;
  severity: string;
  validationStatus: string;
  message: string;
  blocking: boolean;
};

@Injectable()
export class RulesRepository {
  constructor(
    @InjectRepository(ValidationResultEntity)
    private readonly validationResultRepository: Repository<ValidationResultEntity>,
  ) {}

  async createValidationResult(params: CreateValidationResultParams) {
    const entity = this.validationResultRepository.create({
      id: randomUUID(),
      sessionId: params.sessionId ?? null,
      quoteRequestId: params.quoteRequestId ?? null,
      orderId: params.orderId ?? null,
      validationScope: params.validationScope,
      ruleCode: params.ruleCode,
      severity: params.severity,
      validationStatus: params.validationStatus,
      message: params.message,
      blocking: params.blocking,
    });

    return this.validationResultRepository.save(entity);
  }

  async deleteValidationResultsByQuoteRequestId(quoteRequestId: string) {
    await this.validationResultRepository.delete({
      quoteRequestId,
    });
  }
}
