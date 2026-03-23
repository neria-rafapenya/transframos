import { IsBoolean, IsNumber, IsOptional, Min } from 'class-validator';

export class CalculatePriceDto {
  @IsOptional()
  @IsBoolean()
  clearPreviousOptions?: boolean = true;

  @IsOptional()
  @IsNumber()
  @Min(1)
  estimatedKm?: number;

  @IsOptional()
  @IsNumber()
  @Min(0.01)
  estimatedTransitHours?: number;

  @IsOptional()
  @IsNumber()
  @Min(0.01)
  baseRatePerKm?: number;

  @IsOptional()
  @IsNumber()
  @Min(0.1)
  urgencyFactor?: number;
}
