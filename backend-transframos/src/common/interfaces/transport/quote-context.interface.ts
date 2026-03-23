import { QuoteRequestEntity } from '../../../modules/quote/entities/quote-request.entity';
import { QuoteOptionEntity } from '../../../modules/quote/entities/quote-option.entity';
import { SessionStepStateEntity } from '../../../modules/wizard/entities/session-step-state.entity';

export interface QuoteContextInterface {
  quoteRequest: QuoteRequestEntity;
  wizardStates: SessionStepStateEntity[];
  topOption: QuoteOptionEntity | null;
  missingFields: string[];
}
