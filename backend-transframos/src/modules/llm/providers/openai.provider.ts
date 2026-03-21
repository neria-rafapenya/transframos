import { ConfigService } from '@nestjs/config';
import OpenAI from 'openai';
import {
  LlmGenerateTextParams,
  LlmGenerateTextResult,
  LlmProvider,
} from '../interfaces/llm-provider.interface';

export class OpenAiProvider implements LlmProvider {
  private readonly client: OpenAI;
  private readonly model: string;
  private readonly baseUrl: string;

  constructor(private readonly configService: ConfigService) {
    const apiKey = this.configService.get<string>('OPENAI_API_KEY');

    if (!apiKey) {
      throw new Error('OPENAI_API_KEY is required');
    }

    this.model =
      this.configService.get<string>('OPENAI_MODEL') ?? 'gpt-4.1-mini';

    this.baseUrl =
      this.configService.get<string>('OPENAI_BASE_URL') ??
      'https://api.openai.com/v1';

    this.client = new OpenAI({
      apiKey,
      baseURL: this.baseUrl,
    });
  }

  async generateText(
    params: LlmGenerateTextParams,
  ): Promise<LlmGenerateTextResult> {
    const response = await this.client.responses.create({
      model: this.model,
      input: params.prompt,
      instructions: params.instructions,
      temperature: params.temperature,
      max_output_tokens: params.max_output_tokens,
    });

    return {
      provider: 'openai',
      model: response.model ?? this.model,
      text: response.output_text ?? '',
      inputTokens: response.usage?.input_tokens,
      outputTokens: response.usage?.output_tokens,
    };
  }
}
