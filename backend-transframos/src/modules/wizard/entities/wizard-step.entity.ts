import {
  Column,
  CreateDateColumn,
  Entity,
  OneToMany,
  PrimaryColumn,
  UpdateDateColumn,
} from 'typeorm';
import { SessionStepStateEntity } from './session-step-state.entity';

@Entity({ name: 'tra_ai_wizard_steps' })
export class WizardStepEntity {
  @PrimaryColumn({ name: 'wizard_step_id', type: 'char', length: 36 })
  id: string;

  @Column({ name: 'step_code', type: 'varchar', length: 40, unique: true })
  code: string;

  @Column({ name: 'step_label', type: 'varchar', length: 120 })
  label: string;

  @Column({ name: 'step_order', type: 'int' })
  stepOrder: number;

  @Column({
    name: 'maps_to_table',
    type: 'varchar',
    length: 60,
    nullable: true,
  })
  mapsToTable: string | null;

  @Column({
    name: 'maps_to_field',
    type: 'varchar',
    length: 80,
    nullable: true,
  })
  mapsToField: string | null;

  @Column({ name: 'is_required', type: 'boolean', default: true })
  isRequired: boolean;

  @Column({ name: 'allow_free_text', type: 'boolean', default: true })
  allowFreeText: boolean;

  @Column({ name: 'active', type: 'boolean', default: true })
  active: boolean;

  @CreateDateColumn({ name: 'created_at', type: 'timestamp' })
  createdAt: Date;

  @UpdateDateColumn({ name: 'updated_at', type: 'timestamp' })
  updatedAt: Date;

  @OneToMany(() => SessionStepStateEntity, (state) => state.wizardStep)
  sessionStepStates: SessionStepStateEntity[];
}
