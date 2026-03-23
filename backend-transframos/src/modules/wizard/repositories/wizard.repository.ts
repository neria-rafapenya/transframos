import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { randomUUID } from 'crypto';
import { Repository } from 'typeorm';
import { SessionStepStateEntity } from '../entities/session-step-state.entity';
import { WizardStepEntity } from '../entities/wizard-step.entity';

type CreateSessionStepStateParams = {
  sessionId: string;
  quoteRequestId?: string | null;
  wizardStepId: string;
  status: string;
  rawValueText: string | null;
  normalizedValueJson: Record<string, unknown> | null;
  confidenceScore?: number | null;
  sourceMessageId?: string | null;
  askedAt?: Date | null;
  answeredAt?: Date | null;
};

type UpdateSessionStepStateParams = {
  quoteRequestId?: string | null;
  status?: string;
  rawValueText?: string | null;
  normalizedValueJson?: Record<string, unknown> | null;
  confidenceScore?: number | null;
  sourceMessageId?: string | null;
  askedAt?: Date | null;
  answeredAt?: Date | null;
};

@Injectable()
export class WizardRepository {
  constructor(
    @InjectRepository(WizardStepEntity)
    private readonly wizardStepRepository: Repository<WizardStepEntity>,
    @InjectRepository(SessionStepStateEntity)
    private readonly sessionStepStateRepository: Repository<SessionStepStateEntity>,
  ) {}

  async findSteps() {
    return this.wizardStepRepository.find({
      where: { active: true },
      order: { stepOrder: 'ASC' },
    });
  }

  async findStepByCode(code: string) {
    return this.wizardStepRepository.findOne({
      where: { code },
    });
  }

  async findSessionStepStates(sessionId: string) {
    return this.sessionStepStateRepository.find({
      where: { sessionId },
      relations: {
        wizardStep: true,
      },
      order: {
        wizardStep: {
          stepOrder: 'ASC',
        },
      },
    });
  }

  async findSessionStepState(sessionId: string, wizardStepId: string) {
    return this.sessionStepStateRepository.findOne({
      where: {
        sessionId,
        wizardStepId,
      },
      relations: {
        wizardStep: true,
      },
    });
  }

  async createSessionStepState(params: CreateSessionStepStateParams) {
    const entity = this.sessionStepStateRepository.create({
      id: randomUUID(),
      sessionId: params.sessionId,
      quoteRequestId: params.quoteRequestId ?? null,
      wizardStepId: params.wizardStepId,
      status: params.status,
      rawValueText: params.rawValueText,
      normalizedValueJson: params.normalizedValueJson
        ? JSON.stringify(params.normalizedValueJson)
        : null,
      confidenceScore: params.confidenceScore ?? null,
      sourceMessageId: params.sourceMessageId ?? null,
      askedAt: params.askedAt ?? null,
      answeredAt: params.answeredAt ?? null,
    });

    return this.sessionStepStateRepository.save(entity);
  }

  async updateSessionStepState(
    id: string,
    params: UpdateSessionStepStateParams,
  ) {
    const existing = await this.sessionStepStateRepository.findOne({
      where: { id },
      relations: {
        wizardStep: true,
      },
    });

    if (!existing) {
      return null;
    }

    const merged = this.sessionStepStateRepository.merge(existing, {
      quoteRequestId:
        typeof params.quoteRequestId !== 'undefined'
          ? params.quoteRequestId
          : existing.quoteRequestId,
      status:
        typeof params.status !== 'undefined' ? params.status : existing.status,
      rawValueText:
        typeof params.rawValueText !== 'undefined'
          ? params.rawValueText
          : existing.rawValueText,
      normalizedValueJson:
        typeof params.normalizedValueJson !== 'undefined'
          ? params.normalizedValueJson
            ? JSON.stringify(params.normalizedValueJson)
            : null
          : existing.normalizedValueJson,
      confidenceScore:
        typeof params.confidenceScore !== 'undefined'
          ? params.confidenceScore
          : existing.confidenceScore,
      sourceMessageId:
        typeof params.sourceMessageId !== 'undefined'
          ? params.sourceMessageId
          : existing.sourceMessageId,
      askedAt:
        typeof params.askedAt !== 'undefined'
          ? params.askedAt
          : existing.askedAt,
      answeredAt:
        typeof params.answeredAt !== 'undefined'
          ? params.answeredAt
          : existing.answeredAt,
    });

    return this.sessionStepStateRepository.save(merged);
  }
}
