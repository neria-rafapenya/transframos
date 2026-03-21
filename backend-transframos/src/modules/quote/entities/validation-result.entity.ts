import { Column, CreateDateColumn, Entity, PrimaryColumn } from 'typeorm';

@Entity({ name: 'tra_ai_validation_results' })
export class ValidationResultEntity {
  @PrimaryColumn({ name: 'validation_result_id', type: 'char', length: 36 })
  id: string;

  @Column({ name: 'session_id', type: 'char', length: 36, nullable: true })
  sessionId: string | null;

  @Column({
    name: 'quote_request_id',
    type: 'char',
    length: 36,
    nullable: true,
  })
  quoteRequestId: string | null;

  @Column({ name: 'order_id', type: 'char', length: 36, nullable: true })
  orderId: string | null;

  @Column({ name: 'validation_scope', type: 'varchar', length: 30 })
  validationScope: string;

  @Column({ name: 'rule_code', type: 'varchar', length: 40 })
  ruleCode: string;

  @Column({ name: 'severity', type: 'varchar', length: 20 })
  severity: string;

  @Column({ name: 'validation_status', type: 'varchar', length: 20 })
  validationStatus: string;

  @Column({ name: 'message', type: 'text' })
  message: string;

  @Column({ name: 'blocking', type: 'boolean', default: false })
  blocking: boolean;

  @CreateDateColumn({ name: 'created_at', type: 'timestamp' })
  createdAt: Date;
}
