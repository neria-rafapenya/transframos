import { IsObject, IsOptional, IsString, MaxLength } from 'class-validator';

export class StartConversationDto {
  @IsOptional()
  @IsString()
  @MaxLength(255)
  title?: string;

  @IsOptional()
  @IsString()
  @MaxLength(50)
  channel?: string;

  @IsOptional()
  @IsString()
  @MaxLength(10)
  language?: string;

  @IsOptional()
  @IsString()
  initialMessage?: string;

  @IsOptional()
  @IsObject()
  contextJson?: Record<string, unknown>;
}
