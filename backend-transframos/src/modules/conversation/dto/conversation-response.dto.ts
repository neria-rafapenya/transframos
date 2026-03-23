import { ConversationSessionEntity } from '../entities/conversation-session.entity';
import { ConversationMessageEntity } from '../entities/conversation-message.entity';
import { SessionStepStateEntity } from '../../wizard/entities/session-step-state.entity';

export class ConversationResponseDto {
  session: ConversationSessionEntity;
  messages: ConversationMessageEntity[];
  assistantMessage: string | null;
  wizard: SessionStepStateEntity[];
  currentStep: SessionStepStateEntity | null;
  quoteRequest: unknown | null;
  topOption: unknown | null;
  validationSummary: Record<string, unknown> | null;
  routePreview?: unknown | null;
}
