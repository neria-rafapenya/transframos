import { Inject, Injectable } from '@nestjs/common';
import { CreateLlmActionDto } from './dto/create-llm-action.dto';
import { GenerateTextDto } from './dto/generate-text.dto';
import { LlmActionResponseDto } from './dto/llm-action-response.dto';
import { LlmActionsRepository } from './repositories/llm-actions.repository';
import { LLM_PROVIDER_TOKEN } from './constants/llm.constants';
import type { LlmProvider } from './interfaces/llm-provider.interface';

@Injectable()
export class LlmService {
  constructor(
    @Inject(LLM_PROVIDER_TOKEN)
    private readonly llmProvider: LlmProvider,
    private readonly llmActionsRepository: LlmActionsRepository,
  ) {}

  async generateText(
    dto: GenerateTextDto,
    userId?: string | null,
  ): Promise<LlmActionResponseDto> {
    const actionType = dto.actionType ?? 'generate_text';
    const startedAt = Date.now();

    const result = await this.llmProvider.generateText({
      prompt: dto.prompt,
      actionType,
    });

    const actionDto: CreateLlmActionDto = {
      userId: userId ?? null,
      provider: result.provider,
      model: result.model,
      actionType,
      inputText: dto.prompt,
      outputText: result.text,
      status: 'success',
      latencyMs: Date.now() - startedAt,
      tokensInput: result.inputTokens ?? null,
      tokensOutput: result.outputTokens ?? null,
    };

    const action = this.llmActionsRepository.create(actionDto);
    const saved = await this.llmActionsRepository.save(action);

    return {
      id: saved.id,
      text: saved.outputText ?? '',
      provider: saved.provider,
      model: saved.model,
      actionType: saved.actionType,
      createdAt: saved.createdAt,
    };
  }
}
