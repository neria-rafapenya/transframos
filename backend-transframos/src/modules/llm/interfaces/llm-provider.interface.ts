export interface LlmGenerateTextParams {
  prompt: string;
  actionType: string;
  instructions?: string;
  temperature?: number;
  max_output_tokens?: number;
}

export interface LlmGenerateTextResult {
  provider: string;
  model: string;
  text: string;
  inputTokens?: number;
  outputTokens?: number;
}

export interface LlmProvider {
  generateText(params: LlmGenerateTextParams): Promise<LlmGenerateTextResult>;
}
