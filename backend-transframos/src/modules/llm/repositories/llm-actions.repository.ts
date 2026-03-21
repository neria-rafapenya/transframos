import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { randomUUID } from 'crypto';
import { Repository } from 'typeorm';
import { CreateLlmActionDto } from '../dto/create-llm-action.dto';
import { LlmAction } from '../entities/llm-action.entity';

@Injectable()
export class LlmActionsRepository {
  constructor(
    @InjectRepository(LlmAction)
    private readonly repository: Repository<LlmAction>,
  ) {}

  create(data: CreateLlmActionDto): LlmAction {
    return this.repository.create({
      id: randomUUID(),
      userId: data.userId ?? null,
      provider: data.provider,
      model: data.model,
      actionType: data.actionType,
      inputText: data.inputText ?? null,
      inputJson: data.inputJson ?? null,
      outputText: data.outputText ?? null,
      outputJson: data.outputJson ?? null,
      status: data.status,
      errorMessage: data.errorMessage ?? null,
      latencyMs: data.latencyMs ?? null,
      tokensInput: data.tokensInput ?? null,
      tokensOutput: data.tokensOutput ?? null,
    });
  }

  save(action: LlmAction): Promise<LlmAction> {
    return this.repository.save(action);
  }
}
