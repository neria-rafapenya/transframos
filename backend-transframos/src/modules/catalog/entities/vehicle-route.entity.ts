import {
  Column,
  CreateDateColumn,
  Entity,
  PrimaryColumn,
  UpdateDateColumn,
} from 'typeorm';

@Entity({ name: 'tra_vehicle_routes' })
export class VehicleRouteEntity {
  @PrimaryColumn({ name: 'vehicle_route_id', type: 'char', length: 36 })
  id: string;

  @Column({ name: 'vehicle_id', type: 'char', length: 36 })
  vehicleId: string;

  @Column({ name: 'route_id', type: 'char', length: 36 })
  routeId: string;

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
