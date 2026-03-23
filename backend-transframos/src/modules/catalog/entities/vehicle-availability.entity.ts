import {
  Column,
  CreateDateColumn,
  Entity,
  JoinColumn,
  ManyToOne,
  PrimaryColumn,
  UpdateDateColumn,
} from 'typeorm';
import { VehicleEntity } from './vehicle.entity';

@Entity({ name: 'tra_vehicle_availability' })
export class VehicleAvailabilityEntity {
  @PrimaryColumn({ name: 'vehicle_availability_id', type: 'char', length: 36 })
  id: string;

  @Column({ name: 'vehicle_id', type: 'char', length: 36 })
  vehicleId: string;

  @Column({ name: 'availability_date', type: 'date' })
  availabilityDate: string;

  @Column({ name: 'available_from', type: 'time', nullable: true })
  availableFrom: string | null;

  @Column({ name: 'available_until', type: 'time', nullable: true })
  availableUntil: string | null;

  @Column({ name: 'available', type: 'boolean', default: true })
  available: boolean;

  @Column({
    name: 'unavailability_reason',
    type: 'varchar',
    length: 80,
    nullable: true,
  })
  unavailabilityReason: string | null;

  @Column({
    name: 'current_location',
    type: 'varchar',
    length: 120,
    nullable: true,
  })
  currentLocation: string | null;

  @Column({ name: 'planned_km_limit', type: 'int', nullable: true })
  plannedKmLimit: number | null;

  @Column({ name: 'notes', type: 'text', nullable: true })
  notes: string | null;

  @CreateDateColumn({ name: 'created_at', type: 'timestamp' })
  createdAt: Date;

  @UpdateDateColumn({ name: 'updated_at', type: 'timestamp' })
  updatedAt: Date;

  @ManyToOne(() => VehicleEntity, (vehicle) => vehicle.availability, {
    nullable: false,
  })
  @JoinColumn({ name: 'vehicle_id', referencedColumnName: 'id' })
  vehicle: VehicleEntity;
}
