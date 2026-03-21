import {
  Column,
  CreateDateColumn,
  Entity,
  JoinColumn,
  ManyToOne,
  PrimaryColumn,
} from 'typeorm';
import { ConversationSessionEntity } from './conversation-session.entity';

@Entity({ name: 'tra_ai_conversation_messages' })
export class ConversationMessageEntity {
  @PrimaryColumn({ name: 'message_id', type: 'char', length: 36 })
  id: string;

  @Column({ name: 'session_id', type: 'char', length: 36 })
  sessionId: string;

  @Column({ name: 'message_sequence', type: 'int' })
  messageSequence: number;

  @Column({ name: 'sender_type', type: 'varchar', length: 20 })
  role: string;

  @Column({ name: 'message_text', type: 'text' })
  content: string;

  @Column({ name: 'raw_payload', type: 'longtext', nullable: true })
  rawPayload: string | null;

  @Column({
    name: 'extracted_intent_id',
    type: 'char',
    length: 36,
    nullable: true,
  })
  extractedIntentId: string | null;

  @CreateDateColumn({ name: 'created_at', type: 'timestamp' })
  createdAt: Date;

  @ManyToOne(() => ConversationSessionEntity, (session) => session.messages, {
    onDelete: 'CASCADE',
  })
  @JoinColumn({ name: 'session_id', referencedColumnName: 'id' })
  session: ConversationSessionEntity;
}
