import {
  Column,
  CreateDateColumn,
  Entity,
  PrimaryColumn,
  UpdateDateColumn,
} from 'typeorm';

@Entity({ name: 'tra_routes' })
export class RouteEntity {
  @PrimaryColumn({ name: 'route_id', type: 'char', length: 36 })
  id: string;

  @Column({ name: 'route_code', type: 'varchar', length: 30 })
  code: string;

  @Column({ name: 'route_name', type: 'varchar', length: 150 })
  name: string;

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

  @Column({ name: 'standard_distance_km', type: 'int' })
  standardDistanceKm: number;

  @Column({ name: 'standard_duration_minutes', type: 'int' })
  standardDurationMinutes: number;

  @Column({
    name: 'countries_crossed',
    type: 'varchar',
    length: 120,
    nullable: true,
  })
  countriesCrossed: string | null;

  @Column({
    name: 'toll_cost_estimate',
    type: 'decimal',
    precision: 10,
    scale: 2,
    nullable: true,
  })
  tollCostEstimate: number | null;

  @Column({
    name: 'ferry_cost_estimate',
    type: 'decimal',
    precision: 10,
    scale: 2,
    nullable: true,
  })
  ferryCostEstimate: number | null;

  @Column({
    name: 'co2_estimate_kg',
    type: 'decimal',
    precision: 10,
    scale: 2,
    nullable: true,
  })
  co2EstimateKg: number | null;

  @Column({ name: 'preferred_mode', type: 'varchar', length: 20 })
  preferredMode: string;

  @Column({ name: 'intermodal_possible', type: 'boolean', default: false })
  intermodalPossible: boolean;

  @Column({ name: 'active', type: 'boolean', default: true })
  isActive: boolean;

  @CreateDateColumn({ name: 'created_at', type: 'timestamp' })
  createdAt: Date;

  @UpdateDateColumn({ name: 'updated_at', type: 'timestamp' })
  updatedAt: Date;
}
