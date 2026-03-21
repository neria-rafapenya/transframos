import {
  IsDateString,
  IsNumber,
  IsObject,
  IsOptional,
  IsString,
  MaxLength,
} from 'class-validator';

export class CreateQuoteRequestDto {
  @IsOptional()
  @IsNumber()
  conversationSessionId?: string;

  @IsOptional()
  @IsNumber()
  productId?: number;

  @IsOptional()
  @IsNumber()
  quantityValue?: number;

  @IsOptional()
  @IsString()
  @MaxLength(20)
  quantityUnit?: string;

  @IsOptional()
  @IsNumber()
  originLocationId?: number;

  @IsOptional()
  @IsNumber()
  destinationLocationId?: number;

  @IsOptional()
  @IsDateString()
  requestedPickupAt?: Date;

  @IsOptional()
  @IsDateString()
  deliveryDeadlineAt?: Date;

  @IsOptional()
  @IsString()
  @MaxLength(50)
  wizardStatus?: string;

  @IsOptional()
  @IsString()
  @MaxLength(50)
  validationStatus?: string;

  @IsOptional()
  @IsString()
  @MaxLength(50)
  quoteStatus?: string;

  @IsOptional()
  @IsString()
  notes?: string;

  @IsOptional()
  @IsObject()
  rawRequestJson?: Record<string, unknown>;
}
