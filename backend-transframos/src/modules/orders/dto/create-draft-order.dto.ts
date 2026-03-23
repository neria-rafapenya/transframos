import {
  IsNumber,
  IsObject,
  IsOptional,
  IsString,
  MaxLength,
} from 'class-validator';

export class CreateDraftOrderDto {
  @IsNumber()
  quoteRequestId: number;

  @IsOptional()
  @IsNumber()
  quoteOptionId?: number;

  @IsOptional()
  @IsString()
  @MaxLength(50)
  status?: string;

  @IsOptional()
  @IsString()
  notes?: string;

  @IsOptional()
  @IsObject()
  draftPayloadJson?: Record<string, unknown>;
}
