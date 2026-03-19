import { ConfigService } from '@nestjs/config';
import {
  LlmGenerateTextParams,
  LlmGenerateTextResult,
  LlmProvider,
} from '../interfaces/llm-provider.interface';

export class OpenAiProvider implements LlmProvider {
  private readonly model: string;
  private readonly baseUrl: string;

  constructor(private readonly configService: ConfigService) {
    this.model =
      this.configService.get<string>('OPENAI_MODEL') ?? 'gpt-4.1-mini';

    this.baseUrl =
      this.configService.get<string>('OPENAI_BASE_URL') ??
      'https://api.openai.com/v1';
  }

  async generateText(
    params: LlmGenerateTextParams,
  ): Promise<LlmGenerateTextResult> {
    return {
      provider: 'openai',
      model: this.model,
      text: `OPENAI_PROVIDER_PLACEHOLDER [${this.baseUrl}]: ${params.prompt}`,
    };
  }
}
