export class LlmActionResponseDto {
  id!: string;
  text!: string;
  provider!: string;
  model!: string;
  actionType!: string;
  createdAt!: Date;
}
