import {
  Column,
  CreateDateColumn,
  Entity,
  PrimaryColumn,
  UpdateDateColumn,
} from 'typeorm';

@Entity({ name: 'tra_vehicle_tanks' })
export class VehicleTankEntity {
  @PrimaryColumn({ name: 'vehicle_tank_id', type: 'char', length: 36 })
  id: string;

  @Column({ name: 'vehicle_id', type: 'char', length: 36 })
  vehicleId: string;

  @Column({ name: 'tank_id', type: 'char', length: 36 })
  tankId: string;

  @Column({ name: 'active', type: 'boolean', default: true })
  isActive: boolean;

  @Column({ name: 'valid_from', type: 'date', nullable: true })
  validFrom: string | null;

  @Column({ name: 'valid_to', type: 'date', nullable: true })
  validTo: string | null;

  @Column({ name: 'notes', type: 'text', nullable: true })
  notes: string | null;

  @CreateDateColumn({ name: 'created_at', type: 'timestamp' })
  createdAt: Date;

  @UpdateDateColumn({ name: 'updated_at', type: 'timestamp' })
  updatedAt: Date;
}
