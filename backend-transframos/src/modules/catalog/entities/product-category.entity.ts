import {
  Column,
  CreateDateColumn,
  Entity,
  OneToMany,
  PrimaryColumn,
  UpdateDateColumn,
} from 'typeorm';
import { ProductEntity } from './product.entity';

@Entity({ name: 'tra_product_categories' })
export class ProductCategoryEntity {
  @PrimaryColumn({ name: 'category_id', type: 'char', length: 36 })
  id: string;

  @Column({ name: 'category_code', type: 'varchar', length: 30 })
  code: string;

  @Column({ name: 'category_name', type: 'varchar', length: 80 })
  name: string;

  @Column({ name: 'description', type: 'text', nullable: true })
  description: string | null;

  @Column({ name: 'requires_food_grade', type: 'boolean', default: false })
  requiresFoodGrade: boolean;

  @Column({ name: 'requires_feed_grade', type: 'boolean', default: false })
  requiresFeedGrade: boolean;

  @Column({ name: 'requires_sandach', type: 'boolean', default: false })
  requiresSandach: boolean;

  @Column({ name: 'requires_adr', type: 'boolean', default: false })
  requiresAdr: boolean;

  @Column({ name: 'default_cleaning_level', type: 'varchar', length: 30, nullable: true })
  defaultCleaningLevel: string | null;

  @Column({ name: 'allows_intermodal', type: 'boolean', default: false })
  allowsIntermodal: boolean;

  @Column({ name: 'active', type: 'boolean', default: true })
  isActive: boolean;

  @CreateDateColumn({ name: 'created_at', type: 'timestamp' })
  createdAt: Date;

  @UpdateDateColumn({ name: 'updated_at', type: 'timestamp' })
  updatedAt: Date;

  @OneToMany(() => ProductEntity, (product) => product.category)
  products: ProductEntity[];
}
