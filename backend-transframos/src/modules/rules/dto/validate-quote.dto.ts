import { IsBoolean, IsOptional } from 'class-validator';

export class ValidateQuoteDto {
  @IsOptional()
  @IsBoolean()
  clearPreviousResults?: boolean = true;
}
