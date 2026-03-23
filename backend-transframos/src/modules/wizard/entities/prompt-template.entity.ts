import { Column, Entity, PrimaryGeneratedColumn } from 'typeorm';

@Entity({ name: 'tra_prompt_templates' })
export class PromptTemplateEntity {
  @PrimaryGeneratedColumn()
  id: number;

  @Column({ name: 'code', type: 'varchar', length: 100, unique: true })
  code: string;

  @Column({ name: 'phase_code', type: 'varchar', length: 50 })
  phaseCode: string;

  @Column({ name: 'prompt_type', type: 'varchar', length: 50 })
  promptType: string;

  @Column({ name: 'version', type: 'int', default: 1 })
  version: number;

  @Column({ name: 'language', type: 'varchar', length: 10, default: 'es' })
  language: string;

  @Column({ name: 'template_text', type: 'longtext' })
  templateText: string;

  @Column({ name: 'is_active', type: 'boolean', default: true })
  isActive: boolean;
}
