import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { randomUUID } from 'crypto';
import { Repository } from 'typeorm';
import { ConversationMessageEntity } from '../entities/conversation-message.entity';
import { ConversationSessionEntity } from '../entities/conversation-session.entity';

type CreateSessionParams = {
  userId: string;
  title: string | null;
  status: string;
  channel: string;
  language: string;
  contextJson: Record<string, unknown> | null;
};

type CreateMessageParams = {
  sessionId: string;
  role: string;
  content: string;
  rawPayload: Record<string, unknown> | null;
  extractedIntentId?: string | null;
};

@Injectable()
export class ConversationRepository {
  constructor(
    @InjectRepository(ConversationSessionEntity)
    private readonly sessionRepository: Repository<ConversationSessionEntity>,
    @InjectRepository(ConversationMessageEntity)
    private readonly messageRepository: Repository<ConversationMessageEntity>,
  ) {}

  async createSession(params: CreateSessionParams) {
    const entity = this.sessionRepository.create({
      id: randomUUID(),
      userId: params.userId,
      title: params.title,
      status: params.status,
      channel: params.channel,
      language: params.language,
      contextJson: params.contextJson,
    });

    return this.sessionRepository.save(entity);
  }

  async findSessionById(sessionId: string) {
    return this.sessionRepository.findOne({
      where: { id: sessionId },
    });
  }

  async createMessage(params: CreateMessageParams) {
    const currentCount = await this.messageRepository.count({
      where: { sessionId: params.sessionId },
    });

    const entity = this.messageRepository.create({
      id: randomUUID(),
      sessionId: params.sessionId,
      messageSequence: currentCount + 1,
      role: params.role,
      content: params.content,
      rawPayload: params.rawPayload ? JSON.stringify(params.rawPayload) : null,
      extractedIntentId: params.extractedIntentId ?? null,
    });

    return this.messageRepository.save(entity);
  }

  async findMessagesBySessionId(sessionId: string) {
    return this.messageRepository.find({
      where: { sessionId },
      order: {
        messageSequence: 'ASC',
      },
    });
  }

  async updateSessionTimestamp(sessionId: string) {
    await this.sessionRepository.update(
      { id: sessionId },
      { updatedAt: new Date() },
    );
  }
}
