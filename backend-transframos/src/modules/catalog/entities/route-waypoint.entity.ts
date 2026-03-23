import {
  Column,
  CreateDateColumn,
  Entity,
  PrimaryColumn,
  UpdateDateColumn,
} from 'typeorm';

@Entity({ name: 'tra_route_waypoints' })
export class RouteWaypointEntity {
  @PrimaryColumn({ name: 'route_waypoint_id', type: 'char', length: 36 })
  id: string;

  @Column({ name: 'route_id', type: 'char', length: 36 })
  routeId: string;

  @Column({ name: 'sequence_no', type: 'int' })
  sequenceNo: number;

  @Column({ name: 'waypoint_name', type: 'varchar', length: 150 })
  waypointName: string;

  @Column({ name: 'city', type: 'varchar', length: 100, nullable: true })
  city: string | null;

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

  @Column({ name: 'notes', type: 'text', nullable: true })
  notes: string | null;

  @CreateDateColumn({ name: 'created_at', type: 'timestamp' })
  createdAt: Date;

  @UpdateDateColumn({ name: 'updated_at', type: 'timestamp' })
  updatedAt: Date;
}
