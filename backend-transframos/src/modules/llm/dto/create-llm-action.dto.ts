export class CreateLlmActionDto {
  userId?: string | null;
  provider!: string;
  model!: string;
  actionType!: string;
  inputText?: string | null;
  inputJson?: Record<string, unknown> | null;
  outputText?: string | null;
  outputJson?: Record<string, unknown> | null;
  status!: string;
  errorMessage?: string | null;
  latencyMs?: number | null;
  tokensInput?: number | null;
  tokensOutput?: number | null;
}
