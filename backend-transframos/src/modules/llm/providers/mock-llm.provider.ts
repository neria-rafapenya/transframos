import {
  LlmGenerateTextParams,
  LlmGenerateTextResult,
  LlmProvider,
} from '../interfaces/llm-provider.interface';

export class MockLlmProvider implements LlmProvider {
  async generateText(
    params: LlmGenerateTextParams,
  ): Promise<LlmGenerateTextResult> {
    return {
      provider: 'mock',
      model: 'mock-model',
      text: `MOCK_RESPONSE: ${params.prompt}`,
      inputTokens: 0,
      outputTokens: 0,
    };
  }
}
