import {
  ForbiddenException,
  Injectable,
  NotFoundException,
} from '@nestjs/common';
import type { JwtPayload } from '../../common/interfaces/jwt-payload.interface';
import { ConversationResponseDto } from './dto/conversation-response.dto';
import { SendMessageDto } from './dto/send-message.dto';
import { StartConversationDto } from './dto/start-conversation.dto';
import { ConversationRepository } from './repositories/conversation.repository';
import { ConversationOrchestratorService } from './services/conversation-orchestrator.service';

@Injectable()
export class ConversationService {
  constructor(
    private readonly conversationRepository: ConversationRepository,
    private readonly conversationOrchestratorService: ConversationOrchestratorService,
  ) {}

  async startConversation(
    currentUser: JwtPayload,
    dto: StartConversationDto,
  ): Promise<ConversationResponseDto> {
    const userId = String(currentUser.sub);

    const session = await this.conversationRepository.createSession({
      userId,
      title: dto.title ?? 'Nueva conversación',
      status: 'active',
      channel: dto.channel ?? 'chat',
      language: dto.language ?? 'es',
      contextJson: dto.contextJson ?? null,
    });

    if (dto.initialMessage?.trim()) {
      await this.conversationRepository.createMessage({
        sessionId: session.id,
        role: 'user',
        content: dto.initialMessage.trim(),
        rawPayload: null,
      });
    }

    const messages = await this.conversationRepository.findMessagesBySessionId(
      session.id,
    );

    return {
      session,
      messages,
      assistantMessage: null,
      wizard: [],
      currentStep: null,
      quoteRequest: null,
      topOption: null,
      validationSummary: null,
      routePreview: null,
    };
  }

  async sendMessage(
    sessionId: string,
    currentUser: JwtPayload,
    dto: SendMessageDto,
  ): Promise<ConversationResponseDto> {
    const userId = String(currentUser.sub);

    const session =
      await this.conversationRepository.findSessionById(sessionId);

    if (!session) {
      throw new NotFoundException(
        `No existe ninguna conversación con id ${sessionId}`,
      );
    }

    if (session.userId !== userId) {
      throw new ForbiddenException(
        'No puedes enviar mensajes a una conversación que no te pertenece',
      );
    }

    await this.conversationRepository.createMessage({
      sessionId,
      role: 'user',
      content: dto.message.trim(),
      rawPayload: null,
    });

    const history =
      await this.conversationRepository.findMessagesBySessionId(sessionId);

    const orchestration =
      await this.conversationOrchestratorService.processUserMessage({
        sessionId,
        userId,
        userMessage: dto.message.trim(),
        messageHistory: history.map((item) => ({
          role: item.role,
          content: item.content,
        })),
        forceTramitar: dto.forceTramitar ?? false,
      });

    await this.conversationRepository.createMessage({
      sessionId,
      role: 'assistant',
      content: orchestration.assistantMessage,
      rawPayload: {
        extraction: orchestration.extraction,
        validationSummary: orchestration.validationSummary,
      },
    });

    await this.conversationRepository.updateSessionTimestamp(sessionId);

    const updatedSession =
      await this.conversationRepository.findSessionById(sessionId);
    const updatedMessages =
      await this.conversationRepository.findMessagesBySessionId(sessionId);

    return {
      session: updatedSession!,
      messages: updatedMessages,
      assistantMessage: orchestration.assistantMessage,
      wizard: orchestration.context.wizardStates,
      currentStep:
        orchestration.context.wizardStates.find(
          (item) => item.status !== 'completed',
        ) ?? null,
      quoteRequest: orchestration.context.quoteRequest,
      topOption: orchestration.context.topOption,
      validationSummary: orchestration.validationSummary,
      routePreview: orchestration.routePreview ?? null,
    };
  }

  async getConversationById(
    sessionId: string,
    currentUser: JwtPayload,
  ): Promise<ConversationResponseDto> {
    const userId = String(currentUser.sub);

    const session =
      await this.conversationRepository.findSessionById(sessionId);

    if (!session) {
      throw new NotFoundException(
        `No existe ninguna conversación con id ${sessionId}`,
      );
    }

    if (session.userId !== userId) {
      throw new ForbiddenException(
        'No puedes acceder a una conversación que no te pertenece',
      );
    }

    const messages =
      await this.conversationRepository.findMessagesBySessionId(sessionId);

    return {
      session,
      messages,
      assistantMessage: null,
      wizard: [],
      currentStep: null,
      quoteRequest: null,
      topOption: null,
      validationSummary: null,
      routePreview: null,
    };
  }

  async getConversationMessages(sessionId: string, currentUser: JwtPayload) {
    const userId = String(currentUser.sub);
    const session =
      await this.conversationRepository.findSessionById(sessionId);

    if (!session) {
      throw new NotFoundException(
        `No existe ninguna conversación con id ${sessionId}`,
      );
    }

    if (session.userId !== userId) {
      throw new ForbiddenException(
        'No puedes acceder a los mensajes de una conversación que no te pertenece',
      );
    }

    return this.conversationRepository.findMessagesBySessionId(sessionId);
  }
}
