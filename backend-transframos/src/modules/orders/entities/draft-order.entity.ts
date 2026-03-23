import {
  Column,
  CreateDateColumn,
  Entity,
  PrimaryColumn,
  UpdateDateColumn,
} from 'typeorm';

@Entity({ name: 'tra_ai_draft_orders' })
export class DraftOrderEntity {
  @PrimaryColumn({ name: 'draft_order_id', type: 'char', length: 36 })
  id: string;

  @Column({ name: 'quote_request_id', type: 'char', length: 36 })
  quoteRequestId: string;

  @Column({ name: 'quote_option_id', type: 'char', length: 36, nullable: true })
  quoteOptionId: string | null;

  @Column({ name: 'status', type: 'varchar', length: 50, default: 'draft' })
  status: string;

  @Column({ name: 'notes', type: 'text', nullable: true })
  notes: string | null;

  @Column({ name: 'draft_payload_json', type: 'longtext', nullable: true })
  draftPayloadJson: string | null;

  @CreateDateColumn({ name: 'created_at', type: 'timestamp' })
  createdAt: Date;

  @UpdateDateColumn({ name: 'updated_at', type: 'timestamp' })
  updatedAt: Date;
}
