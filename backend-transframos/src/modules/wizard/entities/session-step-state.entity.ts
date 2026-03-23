import {
  Column,
  CreateDateColumn,
  Entity,
  JoinColumn,
  ManyToOne,
  PrimaryColumn,
  UpdateDateColumn,
} from 'typeorm';
import { WizardStepEntity } from './wizard-step.entity';

@Entity({ name: 'tra_ai_session_step_state' })
export class SessionStepStateEntity {
  @PrimaryColumn({ name: 'session_step_state_id', type: 'char', length: 36 })
  id: string;

  @Column({ name: 'session_id', type: 'char', length: 36 })
  sessionId: string;

  @Column({
    name: 'quote_request_id',
    type: 'char',
    length: 36,
    nullable: true,
  })
  quoteRequestId: string | null;

  @Column({ name: 'wizard_step_id', type: 'char', length: 36 })
  wizardStepId: string;

  @Column({ name: 'step_status', type: 'varchar', length: 20 })
  status: string;

  @Column({ name: 'raw_value_text', type: 'text', nullable: true })
  rawValueText: string | null;

  @Column({ name: 'normalized_value_json', type: 'longtext', nullable: true })
  normalizedValueJson: string | null;

  @Column({
    name: 'confidence_score',
    type: 'decimal',
    precision: 5,
    scale: 2,
    nullable: true,
  })
  confidenceScore: number | null;

  @Column({
    name: 'source_message_id',
    type: 'char',
    length: 36,
    nullable: true,
  })
  sourceMessageId: string | null;

  @Column({ name: 'asked_at', type: 'timestamp', nullable: true })
  askedAt: Date | null;

  @Column({ name: 'answered_at', type: 'timestamp', nullable: true })
  answeredAt: Date | null;

  @CreateDateColumn({ name: 'created_at', type: 'timestamp' })
  createdAt: Date;

  @UpdateDateColumn({ name: 'updated_at', type: 'timestamp' })
  updatedAt: Date;

  @ManyToOne(
    () => WizardStepEntity,
    (wizardStep) => wizardStep.sessionStepStates,
    {
      onDelete: 'RESTRICT',
    },
  )
  @JoinColumn({ name: 'wizard_step_id', referencedColumnName: 'id' })
  wizardStep: WizardStepEntity;
}
