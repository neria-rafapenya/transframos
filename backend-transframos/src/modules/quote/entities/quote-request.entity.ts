import {
  Column,
  CreateDateColumn,
  Entity,
  PrimaryColumn,
  UpdateDateColumn,
} from 'typeorm';

@Entity({ name: 'tra_ai_quote_requests' })
export class QuoteRequestEntity {
  @PrimaryColumn({ name: 'quote_request_id', type: 'char', length: 36 })
  id: string;

  @Column({
    name: 'conversation_session_id',
    type: 'char',
    length: 36,
    nullable: true,
  })
  conversationSessionId: string | null;

  @Column({
    name: 'external_reference',
    type: 'varchar',
    length: 50,
    nullable: true,
  })
  externalReference: string | null;

  @Column({
    name: 'source_channel',
    type: 'varchar',
    length: 20,
    default: 'chat',
  })
  sourceChannel: string;

  @Column({ name: 'client_id', type: 'char', length: 36, nullable: true })
  clientId: string | null;

  @Column({
    name: 'requester_name',
    type: 'varchar',
    length: 150,
    nullable: true,
  })
  requesterName: string | null;

  @Column({
    name: 'requester_email',
    type: 'varchar',
    length: 150,
    nullable: true,
  })
  requesterEmail: string | null;

  @Column({
    name: 'requester_phone',
    type: 'varchar',
    length: 40,
    nullable: true,
  })
  requesterPhone: string | null;

  @Column({ name: 'requested_product_text', type: 'varchar', length: 150 })
  requestedProductText: string;

  @Column({
    name: 'requested_product_id',
    type: 'char',
    length: 36,
    nullable: true,
  })
  requestedProductId: string | null;

  @Column({
    name: 'requested_category_id',
    type: 'char',
    length: 36,
    nullable: true,
  })
  requestedCategoryId: string | null;

  @Column({ name: 'requested_volume_liters', type: 'int', nullable: true })
  requestedVolumeLiters: number | null;

  @Column({
    name: 'requested_weight_tn',
    type: 'decimal',
    precision: 10,
    scale: 2,
    nullable: true,
  })
  requestedWeightTn: number | null;

  @Column({ name: 'requested_load_date', type: 'date', nullable: true })
  requestedLoadDate: string | null;

  @Column({ name: 'origin_text', type: 'varchar', length: 200, nullable: true })
  originText: string | null;

  @Column({
    name: 'destination_text',
    type: 'varchar',
    length: 200,
    nullable: true,
  })
  destinationText: string | null;

  @Column({
    name: 'origin_loading_point_id',
    type: 'char',
    length: 36,
    nullable: true,
  })
  originLoadingPointId: string | null;

  @Column({
    name: 'destination_unloading_point_id',
    type: 'char',
    length: 36,
    nullable: true,
  })
  destinationUnloadingPointId: string | null;

  @Column({ name: 'service_constraints_text', type: 'text', nullable: true })
  serviceConstraintsText: string | null;

  @Column({
    name: 'requested_mode',
    type: 'varchar',
    length: 20,
    nullable: true,
  })
  requestedMode: string | null;

  @Column({ name: 'extracted_json', type: 'longtext', nullable: true })
  extractedJson: string | null;

  @Column({
    name: 'validation_status',
    type: 'varchar',
    length: 20,
    default: 'pending',
  })
  validationStatus: string;

  @CreateDateColumn({ name: 'created_at', type: 'timestamp' })
  createdAt: Date;

  @UpdateDateColumn({ name: 'updated_at', type: 'timestamp' })
  updatedAt: Date;

  @Column({
    name: 'delivery_deadline_datetime',
    type: 'timestamp',
    nullable: true,
  })
  deliveryDeadlineDatetime: Date | null;

  @Column({
    name: 'wizard_status',
    type: 'varchar',
    length: 20,
    default: 'idle',
  })
  wizardStatus: string;
}
