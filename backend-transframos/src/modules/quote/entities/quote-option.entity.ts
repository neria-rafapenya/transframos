import {
  Column,
  CreateDateColumn,
  Entity,
  PrimaryColumn,
  UpdateDateColumn,
} from 'typeorm';

@Entity({ name: 'tra_ai_quote_options' })
export class QuoteOptionEntity {
  @PrimaryColumn({ name: 'quote_option_id', type: 'char', length: 36 })
  id: string;

  @Column({ name: 'quote_request_id', type: 'char', length: 36 })
  quoteRequestId: string;

  @Column({ name: 'vehicle_type_id', type: 'char', length: 36, nullable: true })
  vehicleTypeId: string | null;

  @Column({
    name: 'cleaning_protocol_id',
    type: 'char',
    length: 36,
    nullable: true,
  })
  cleaningProtocolId: string | null;

  @Column({
    name: 'estimated_cost',
    type: 'decimal',
    precision: 12,
    scale: 2,
    nullable: true,
  })
  estimatedCost: number | null;

  @Column({
    name: 'estimated_transit_hours',
    type: 'decimal',
    precision: 10,
    scale: 2,
    nullable: true,
  })
  estimatedTransitHours: number | null;

  @Column({ name: 'is_feasible', type: 'boolean', default: true })
  isFeasible: boolean;

  @Column({
    name: 'recommendation_score',
    type: 'decimal',
    precision: 10,
    scale: 2,
    nullable: true,
  })
  recommendationScore: number | null;

  @Column({ name: 'reasoning_json', type: 'longtext', nullable: true })
  reasoningJson: string | null;

  @Column({ name: 'notes', type: 'text', nullable: true })
  notes: string | null;

  @CreateDateColumn({ name: 'created_at', type: 'timestamp' })
  createdAt: Date;

  @UpdateDateColumn({ name: 'updated_at', type: 'timestamp' })
  updatedAt: Date;
}
