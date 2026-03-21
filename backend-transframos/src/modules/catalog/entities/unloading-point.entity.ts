import { Column, Entity, PrimaryColumn } from 'typeorm';

@Entity({ name: 'tra_unloading_points' })
export class UnloadingPointEntity {
  @PrimaryColumn({ name: 'unloading_point_id', type: 'char', length: 36 })
  id: string;

  @Column({ name: 'client_id', type: 'char', length: 36, nullable: true })
  clientId: string | null;

  @Column({ name: 'point_code', type: 'varchar', length: 30 })
  code: string;

  @Column({ name: 'point_name', type: 'varchar', length: 150 })
  name: string;

  @Column({ name: 'country_code', type: 'char', length: 2 })
  countryCode: string;

  @Column({ name: 'postal_code', type: 'varchar', length: 15, nullable: true })
  postalCode: string | null;

  @Column({ name: 'city', type: 'varchar', length: 100 })
  city: string;

  @Column({ name: 'address_line1', type: 'varchar', length: 200 })
  addressLine1: string;

  @Column({
    name: 'latitude',
    type: 'decimal',
    precision: 9,
    scale: 6,
    nullable: true,
  })
  latitude: number | null;

  @Column({
    name: 'longitude',
    type: 'decimal',
    precision: 9,
    scale: 6,
    nullable: true,
  })
  longitude: number | null;

  @Column({ name: 'unloading_window_start', type: 'time', nullable: true })
  unloadingWindowStart: string | null;

  @Column({ name: 'unloading_window_end', type: 'time', nullable: true })
  unloadingWindowEnd: string | null;

  @Column({
    name: 'unloading_days_mask',
    type: 'varchar',
    length: 20,
    nullable: true,
  })
  unloadingDaysMask: string | null;

  @Column({ name: 'requires_prealert', type: 'boolean', default: false })
  requiresPrealert: boolean;

  @Column({ name: 'discharge_requirements', type: 'text', nullable: true })
  dischargeRequirements: string | null;

  @Column({
    name: 'allowed_vehicle_types',
    type: 'varchar',
    length: 100,
    nullable: true,
  })
  allowedVehicleTypes: string | null;

  @Column({
    name: 'default_contact_id',
    type: 'char',
    length: 36,
    nullable: true,
  })
  defaultContactId: string | null;

  @Column({ name: 'active', type: 'boolean', default: true })
  isActive: boolean;

  @Column({ name: 'notes', type: 'text', nullable: true })
  notes: string | null;
}
