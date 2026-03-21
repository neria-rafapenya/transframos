import {
  IsDateString,
  IsIn,
  IsNumber,
  IsObject,
  IsOptional,
  IsString,
} from 'class-validator';

export class UpdateStepStateDto {
  @IsString()
  @IsIn(['idle', 'pending', 'completed', 'blocked', 'skipped'])
  status: string;

  @IsOptional()
  @IsObject()
  valueJson?: Record<string, unknown>;

  @IsOptional()
  @IsString()
  rawValueText?: string;

  @IsOptional()
  @IsNumber()
  confidenceScore?: number;

  @IsOptional()
  @IsString()
  sourceMessageId?: string;

  @IsOptional()
  @IsString()
  quoteRequestId?: string;

  @IsOptional()
  @IsDateString()
  askedAt?: string;

  @IsOptional()
  @IsDateString()
  answeredAt?: string;
}
