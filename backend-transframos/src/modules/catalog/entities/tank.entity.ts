import { Column, CreateDateColumn, Entity, PrimaryColumn, UpdateDateColumn } from 'typeorm';

@Entity({ name: 'tra_tanks' })
export class TankEntity {
  @PrimaryColumn({ name: 'tank_id', type: 'char', length: 36 })
  id: string;

  @Column({ name: 'tank_code', type: 'varchar', length: 30 })
  code: string;

  @Column({ name: 'tank_type', type: 'varchar', length: 30 })
  type: string;

  @Column({ name: 'capacity_liters', type: 'int' })
  capacityLiters: number;

  @Column({
    name: 'max_payload_tn',
    type: 'decimal',
    precision: 5,
    scale: 2,
  })
  maxPayloadTn: number;

  @Column({ name: 'temperature_control', type: 'boolean', default: false })
  temperatureControl: boolean;

  @Column({ name: 'heating_system', type: 'boolean', default: false })
  heatingSystem: boolean;

  @Column({ name: 'cooling_system', type: 'boolean', default: false })
  coolingSystem: boolean;

  @Column({ name: 'self_unloading', type: 'boolean', default: false })
  selfUnloading: boolean;

  @Column({ name: 'bacteriological_filter', type: 'boolean', default: false })
  bacteriologicalFilter: boolean;

  @Column({ name: 'compartment_count', type: 'int' })
  compartmentCount: number;

  @Column({ name: 'dedicated_use', type: 'varchar', length: 30, nullable: true })
  dedicatedUse: string | null;

  @Column({ name: 'cleaning_status', type: 'varchar', length: 20 })
  cleaningStatus: string;

  @Column({ name: 'current_location', type: 'varchar', length: 120, nullable: true })
  currentLocation: string | null;

  @Column({ name: 'ownership_type', type: 'varchar', length: 20 })
  ownershipType: string;

  @Column({ name: 'active', type: 'boolean', default: true })
  isActive: boolean;

  @Column({ name: 'last_cleaning_date', type: 'date', nullable: true })
  lastCleaningDate: string | null;

  @CreateDateColumn({ name: 'created_at', type: 'timestamp' })
  createdAt: Date;

  @UpdateDateColumn({ name: 'updated_at', type: 'timestamp' })
  updatedAt: Date;

  @Column({ name: 'notes', type: 'text', nullable: true })
  notes: string | null;
}
