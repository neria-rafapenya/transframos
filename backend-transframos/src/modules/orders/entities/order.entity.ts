import {
  Column,
  CreateDateColumn,
  Entity,
  PrimaryColumn,
  UpdateDateColumn,
} from 'typeorm';

@Entity({ name: 'tra_orders' })
export class OrderEntity {
  @PrimaryColumn({ name: 'order_id', type: 'char', length: 36 })
  id: string;

  @Column({ name: 'order_number', type: 'varchar', length: 40 })
  orderNumber: string;

  @Column({ name: 'client_id', type: 'char', length: 36 })
  clientId: string;

  @Column({ name: 'quote_id', type: 'char', length: 36, nullable: true })
  quoteId: string | null;

  @Column({ name: 'product_id', type: 'char', length: 36 })
  productId: string;

  @Column({ name: 'category_id', type: 'char', length: 36 })
  categoryId: string;

  @Column({ name: 'origin_loading_point_id', type: 'char', length: 36 })
  originLoadingPointId: string;

  @Column({
    name: 'destination_unloading_point_id',
    type: 'char',
    length: 36,
  })
  destinationUnloadingPointId: string;

  @Column({
    name: 'requested_pickup_datetime',
    type: 'timestamp',
    nullable: true,
  })
  requestedPickupDatetime: Date | null;

  @Column({
    name: 'requested_delivery_datetime',
    type: 'timestamp',
    nullable: true,
  })
  requestedDeliveryDatetime: Date | null;

  @Column({
    name: 'confirmed_pickup_datetime',
    type: 'timestamp',
    nullable: true,
  })
  confirmedPickupDatetime: Date | null;

  @Column({
    name: 'confirmed_delivery_datetime',
    type: 'timestamp',
    nullable: true,
  })
  confirmedDeliveryDatetime: Date | null;

  @Column({ name: 'ordered_volume_liters', type: 'int' })
  orderedVolumeLiters: number;

  @Column({
    name: 'ordered_weight_tn',
    type: 'decimal',
    precision: 5,
    scale: 2,
    nullable: true,
  })
  orderedWeightTn: number | null;

  @Column({ name: 'service_mode', type: 'varchar', length: 20 })
  serviceMode: string;

  @Column({ name: 'order_status', type: 'varchar', length: 20 })
  orderStatus: string;

  @Column({ name: 'priority_level', type: 'varchar', length: 20, nullable: true })
  priorityLevel: string | null;

  @Column({
    name: 'client_reference',
    type: 'varchar',
    length: 80,
    nullable: true,
  })
  clientReference: string | null;

  @Column({ name: 'internal_notes', type: 'text', nullable: true })
  internalNotes: string | null;

  @CreateDateColumn({ name: 'created_at', type: 'timestamp' })
  createdAt: Date;

  @UpdateDateColumn({ name: 'updated_at', type: 'timestamp' })
  updatedAt: Date;
}
