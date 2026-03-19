export interface LlmGenerateTextParams {
  prompt: string;
  actionType: string;
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
