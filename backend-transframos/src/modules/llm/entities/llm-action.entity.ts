import {
  Column,
  CreateDateColumn,
  Entity,
  JoinColumn,
  ManyToOne,
  PrimaryColumn,
} from 'typeorm';
import { User } from '../../users/entities/user.entity';

@Entity({ name: 'tra_llm_actions' })
export class LlmAction {
  @PrimaryColumn({ name: 'id', type: 'char', length: 36 })
  id: string;

  @Column({ name: 'user_id', type: 'char', length: 36, nullable: true })
  userId: string | null;

  @Column({ name: 'provider', type: 'varchar', length: 100 })
  provider: string;

  @Column({ name: 'model', type: 'varchar', length: 100 })
  model: string;

  @Column({ name: 'action_type', type: 'varchar', length: 100 })
  actionType: string;

  @Column({ name: 'input_text', type: 'longtext', nullable: true })
  inputText: string | null;

  @Column({ name: 'input_json', type: 'json', nullable: true })
  inputJson: Record<string, unknown> | null;

  @Column({ name: 'output_text', type: 'longtext', nullable: true })
  outputText: string | null;

  @Column({ name: 'output_json', type: 'json', nullable: true })
  outputJson: Record<string, unknown> | null;

  @Column({ name: 'status', type: 'varchar', length: 50 })
  status: string;

  @Column({ name: 'error_message', type: 'text', nullable: true })
  errorMessage: string | null;

  @Column({ name: 'latency_ms', type: 'int', nullable: true })
  latencyMs: number | null;

  @Column({ name: 'tokens_input', type: 'int', nullable: true })
  tokensInput: number | null;

  @Column({ name: 'tokens_output', type: 'int', nullable: true })
  tokensOutput: number | null;

  @CreateDateColumn({ name: 'created_at', type: 'datetime' })
  createdAt: Date;

  @ManyToOne(() => User, (user) => user.llmActions, {
    nullable: true,
    onDelete: 'SET NULL',
  })
  @JoinColumn({ name: 'user_id' })
  user: User | null;
}
