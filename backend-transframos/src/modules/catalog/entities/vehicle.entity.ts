import {
  Column,
  CreateDateColumn,
  Entity,
  OneToMany,
  PrimaryColumn,
  UpdateDateColumn,
} from 'typeorm';
import { VehicleAvailabilityEntity } from './vehicle-availability.entity';

@Entity({ name: 'tra_vehicles' })
export class VehicleEntity {
  @PrimaryColumn({ name: 'vehicle_id', type: 'char', length: 36 })
  id: string;

  @Column({ name: 'vehicle_code', type: 'varchar', length: 30, unique: true })
  code: string;

  @Column({ name: 'plate_number', type: 'varchar', length: 20 })
  plateNumber: string;

  @Column({ name: 'vehicle_type', type: 'varchar', length: 20 })
  vehicleTypeCode: string;

  @Column({ name: 'home_base', type: 'varchar', length: 120, nullable: true })
  homeBase: string | null;

  @Column({ name: 'euro_class', type: 'varchar', length: 20, nullable: true })
  euroClass: string | null;

  @Column({ name: 'max_daily_km', type: 'int', nullable: true })
  maxDailyKm: number | null;

  @Column({ name: 'max_weekly_km', type: 'int', nullable: true })
  maxWeeklyKm: number | null;

  @Column({ name: 'gps_enabled', type: 'boolean', default: false })
  gpsEnabled: boolean;

  @Column({ name: 'intermodal_capable', type: 'boolean', default: false })
  intermodalCapable: boolean;

  @Column({ name: 'maintenance_status', type: 'varchar', length: 20 })
  maintenanceStatus: string;

  @Column({ name: 'last_maintenance_date', type: 'date', nullable: true })
  lastMaintenanceDate: Date | null;

  @Column({ name: 'next_maintenance_date', type: 'date', nullable: true })
  nextMaintenanceDate: Date | null;

  @Column({ name: 'active', type: 'boolean', default: true })
  isActive: boolean;

  @CreateDateColumn({ name: 'created_at', type: 'timestamp' })
  createdAt: Date;

  @UpdateDateColumn({ name: 'updated_at', type: 'timestamp' })
  updatedAt: Date;

  @OneToMany(
    () => VehicleAvailabilityEntity,
    (availability) => availability.vehicle,
  )
  availability: VehicleAvailabilityEntity[];
}
