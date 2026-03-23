import { Injectable, NotFoundException } from '@nestjs/common';
import { UpdateStepStateDto } from './dto/update-step-state.dto';
import { WizardRepository } from './repositories/wizard.repository';

@Injectable()
export class WizardService {
  constructor(private readonly wizardRepository: WizardRepository) {}

  async getSteps() {
    return this.wizardRepository.findSteps();
  }

  async getStepByCode(code: string) {
    const step = await this.wizardRepository.findStepByCode(code);

    if (!step) {
      throw new NotFoundException(`No existe ningún paso con código ${code}`);
    }

    return step;
  }

  async initializeSessionSteps(sessionId: string) {
    const steps = await this.wizardRepository.findSteps();

    for (const step of steps) {
      const existing = await this.wizardRepository.findSessionStepState(
        sessionId,
        step.id,
      );

      if (!existing) {
        await this.wizardRepository.createSessionStepState({
          sessionId,
          wizardStepId: step.id,
          status: step.isRequired ? 'pending' : 'idle',
          rawValueText: null,
          normalizedValueJson: null,
        });
      }
    }

    return this.getSessionStepStates(sessionId);
  }

  async getSessionStepStates(sessionId: string) {
    return this.wizardRepository.findSessionStepStates(sessionId);
  }

  async getCurrentStep(sessionId: string) {
    const states = await this.wizardRepository.findSessionStepStates(sessionId);

    return states.find((item) => item.status !== 'completed') ?? null;
  }

  async upsertSessionStepState(
    sessionId: string,
    stepCode: string,
    dto: UpdateStepStateDto,
  ) {
    const step = await this.wizardRepository.findStepByCode(stepCode);

    if (!step) {
      throw new NotFoundException(
        `No existe ningún paso del wizard con código ${stepCode}`,
      );
    }

    const existing = await this.wizardRepository.findSessionStepState(
      sessionId,
      step.id,
    );

    if (!existing) {
      return this.wizardRepository.createSessionStepState({
        sessionId,
        quoteRequestId: dto.quoteRequestId ?? null,
        wizardStepId: step.id,
        status: dto.status,
        rawValueText: dto.rawValueText ?? null,
        normalizedValueJson: dto.valueJson ?? null,
        confidenceScore: dto.confidenceScore ?? null,
        sourceMessageId: dto.sourceMessageId ?? null,
        askedAt: dto.askedAt ? new Date(dto.askedAt) : null,
        answeredAt: dto.answeredAt ? new Date(dto.answeredAt) : null,
      });
    }

    return this.wizardRepository.updateSessionStepState(existing.id, {
      quoteRequestId:
        typeof dto.quoteRequestId !== 'undefined'
          ? dto.quoteRequestId
          : undefined,
      status: dto.status,
      rawValueText:
        typeof dto.rawValueText !== 'undefined' ? dto.rawValueText : undefined,
      normalizedValueJson:
        typeof dto.valueJson !== 'undefined' ? dto.valueJson : undefined,
      confidenceScore:
        typeof dto.confidenceScore !== 'undefined'
          ? dto.confidenceScore
          : undefined,
      sourceMessageId:
        typeof dto.sourceMessageId !== 'undefined'
          ? dto.sourceMessageId
          : undefined,
      askedAt:
        typeof dto.askedAt !== 'undefined'
          ? dto.askedAt
            ? new Date(dto.askedAt)
            : null
          : undefined,
      answeredAt:
        typeof dto.answeredAt !== 'undefined'
          ? dto.answeredAt
            ? new Date(dto.answeredAt)
            : null
          : undefined,
    });
  }
}
