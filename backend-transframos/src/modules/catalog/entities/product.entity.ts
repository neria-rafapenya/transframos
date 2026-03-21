import {
  Column,
  Entity,
  JoinColumn,
  ManyToOne,
  PrimaryColumn,
} from 'typeorm';
import { ProductCategoryEntity } from './product-category.entity';

@Entity({ name: 'tra_products' })
export class ProductEntity {
  @PrimaryColumn({ name: 'product_id', type: 'char', length: 36 })
  id: string;

  @Column({ name: 'product_code', type: 'varchar', length: 30 })
  code: string;

  @Column({ name: 'product_name', type: 'varchar', length: 120 })
  name: string;

  @Column({ name: 'commercial_name', type: 'varchar', length: 120, nullable: true })
  commercialName: string | null;

  @Column({ name: 'category_id', type: 'char', length: 36 })
  categoryId: string;

  @Column({
    name: 'density_kg_l',
    type: 'decimal',
    precision: 5,
    scale: 3,
    nullable: true,
  })
  densityKgL: number | null;

  @Column({ name: 'adr_required', type: 'boolean', default: false })
  adrRequired: boolean;

  @Column({ name: 'adr_class', type: 'varchar', length: 20, nullable: true })
  adrClass: string | null;

  @Column({ name: 'food_grade_required', type: 'boolean', default: false })
  foodGradeRequired: boolean;

  @Column({ name: 'feed_grade_required', type: 'boolean', default: false })
  feedGradeRequired: boolean;

  @Column({ name: 'sandach_required', type: 'boolean', default: false })
  sandachRequired: boolean;

  @Column({
    name: 'temperature_min_c',
    type: 'decimal',
    precision: 4,
    scale: 1,
    nullable: true,
  })
  temperatureMinC: number | null;

  @Column({
    name: 'temperature_max_c',
    type: 'decimal',
    precision: 4,
    scale: 1,
    nullable: true,
  })
  temperatureMaxC: number | null;

  @Column({ name: 'needs_heating', type: 'boolean', default: false })
  needsHeating: boolean;

  @Column({ name: 'needs_cooling', type: 'boolean', default: false })
  needsCooling: boolean;

  @Column({
    name: 'needs_bacteriological_filter',
    type: 'boolean',
    default: false,
  })
  needsBacteriologicalFilter: boolean;

  @Column({ name: 'viscosity_level', type: 'varchar', length: 20, nullable: true })
  viscosityLevel: string | null;

  @Column({
    name: 'cleaning_level_required',
    type: 'varchar',
    length: 30,
    nullable: true,
  })
  cleaningLevelRequired: string | null;

  @Column({
    name: 'discharge_type_required',
    type: 'varchar',
    length: 30,
    nullable: true,
  })
  dischargeTypeRequired: string | null;

  @Column({ name: 'default_max_transport_hours', type: 'int', nullable: true })
  defaultMaxTransportHours: number | null;

  @Column({ name: 'active', type: 'boolean', default: true })
  isActive: boolean;

  @Column({ name: 'notes', type: 'text', nullable: true })
  notes: string | null;

  @ManyToOne(() => ProductCategoryEntity, (category) => category.products, {
    nullable: false,
  })
  @JoinColumn({ name: 'category_id' })
  category: ProductCategoryEntity;
}
