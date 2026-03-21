import { Column, Entity, PrimaryColumn } from 'typeorm';

@Entity({ name: 'tra_product_compatibility_rules' })
export class ProductCompatibilityRuleEntity {
  @PrimaryColumn({ name: 'compatibility_rule_id', type: 'char', length: 36 })
  id: string;

  @Column({
    name: 'previous_product_id',
    type: 'char',
    length: 36,
    nullable: true,
  })
  previousProductId: string | null;

  @Column({
    name: 'next_product_id',
    type: 'char',
    length: 36,
    nullable: true,
  })
  nextProductId: string | null;

  @Column({
    name: 'previous_category_id',
    type: 'char',
    length: 36,
    nullable: true,
  })
  previousCategoryId: string | null;

  @Column({
    name: 'next_category_id',
    type: 'char',
    length: 36,
    nullable: true,
  })
  nextCategoryId: string | null;

  @Column({ name: 'cleaning_required', type: 'boolean', default: false })
  cleaningRequired: boolean;

  @Column({
    name: 'required_cleaning_type',
    type: 'varchar',
    length: 30,
    nullable: true,
  })
  requiredCleaningType: string | null;

  @Column({
    name: 'cooling_or_heating_reset_required',
    type: 'boolean',
    default: false,
  })
  coolingOrHeatingResetRequired: boolean;

  @Column({
    name: 'bacteriological_filter_required',
    type: 'boolean',
    default: false,
  })
  bacteriologicalFilterRequired: boolean;

  @Column({ name: 'compatibility_status', type: 'varchar', length: 20 })
  compatibilityStatus: string;

  @Column({ name: 'rationale', type: 'text', nullable: true })
  rationale: string | null;

  @Column({ name: 'active', type: 'boolean', default: true })
  isActive: boolean;

  @Column({ name: 'valid_from', type: 'date', nullable: true })
  validFrom: string | null;

  @Column({ name: 'valid_to', type: 'date', nullable: true })
  validTo: string | null;
}
