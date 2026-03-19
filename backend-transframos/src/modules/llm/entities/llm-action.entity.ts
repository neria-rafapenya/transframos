import {
  Column,
  CreateDateColumn,
  Entity,
  Index,
  JoinColumn,
  ManyToOne,
  PrimaryGeneratedColumn,
} from 'typeorm';
import { User } from '../../users/entities/user.entity';

@Entity({ name: 'llm_actions' })
export class LlmAction {
  @PrimaryGeneratedColumn('uuid')
  id!: string;

  @Index('idx_llm_actions_user_id')
  @Column({ name: 'user_id', type: 'char', length: 36, nullable: true })
  userId!: string | null;

  @ManyToOne(() => User, (user) => user.llmActions, {
    onDelete: 'SET NULL',
    nullable: true,
  })
  @JoinColumn({ name: 'user_id' })
  user!: User | null;

  @Column({ type: 'varchar', length: 100 })
  provider!: string;

  @Column({ type: 'varchar', length: 150 })
  model!: string;

  @Column({ name: 'action_type', type: 'varchar', length: 100 })
  actionType!: string;

  @Column({ name: 'input_text', type: 'longtext', nullable: true })
  inputText!: string | null;

  @Column({ name: 'input_json', type: 'json', nullable: true })
  inputJson!: Record<string, unknown> | null;

  @Column({ name: 'output_text', type: 'longtext', nullable: true })
  outputText!: string | null;

  @Column({ name: 'output_json', type: 'json', nullable: true })
  outputJson!: Record<string, unknown> | null;

  @Column({ type: 'varchar', length: 50, default: 'pending' })
  status!: string;

  @Column({ name: 'error_message', type: 'text', nullable: true })
  errorMessage!: string | null;

  @Column({ name: 'latency_ms', type: 'int', nullable: true })
  latencyMs!: number | null;

  @Column({ name: 'tokens_input', type: 'int', nullable: true })
  tokensInput!: number | null;

  @Column({ name: 'tokens_output', type: 'int', nullable: true })
  tokensOutput!: number | null;

  @CreateDateColumn({ name: 'created_at' })
  createdAt!: Date;
}
