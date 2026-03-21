import {
  Column,
  CreateDateColumn,
  Entity,
  OneToMany,
  PrimaryColumn,
  UpdateDateColumn,
} from 'typeorm';
import { ConversationMessageEntity } from './conversation-message.entity';

@Entity({ name: 'tra_ai_conversation_sessions' })
export class ConversationSessionEntity {
  @PrimaryColumn({ name: 'session_id', type: 'char', length: 36 })
  id: string;

  @Column({ name: 'user_id', type: 'char', length: 36 })
  userId: string;

  @Column({ name: 'title', type: 'varchar', length: 255, nullable: true })
  title: string | null;

  @Column({ name: 'status', type: 'varchar', length: 50, default: 'active' })
  status: string;

  @Column({ name: 'channel', type: 'varchar', length: 50, default: 'chat' })
  channel: string;

  @Column({ name: 'language', type: 'varchar', length: 10, default: 'es' })
  language: string;

  @Column({ name: 'context_json', type: 'json', nullable: true })
  contextJson: Record<string, unknown> | null;

  @CreateDateColumn({ name: 'created_at', type: 'timestamp' })
  createdAt: Date;

  @UpdateDateColumn({ name: 'updated_at', type: 'timestamp' })
  updatedAt: Date;

  @OneToMany(() => ConversationMessageEntity, (message) => message.session)
  messages: ConversationMessageEntity[];
}
