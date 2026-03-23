import { QuoteRequestEntity } from '../entities/quote-request.entity';
import { QuoteOptionEntity } from '../entities/quote-option.entity';
import { ValidationResultEntity } from '../entities/validation-result.entity';

export class QuoteResponseDto {
  quoteRequest: QuoteRequestEntity;
  options: QuoteOptionEntity[];
  validationResults: ValidationResultEntity[];
}
