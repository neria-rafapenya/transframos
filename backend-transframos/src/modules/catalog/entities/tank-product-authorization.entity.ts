import {
  Column,
  CreateDateColumn,
  Entity,
  PrimaryColumn,
  UpdateDateColumn,
} from 'typeorm';

@Entity({ name: 'tra_tank_product_authorizations' })
export class TankProductAuthorizationEntity {
  @PrimaryColumn({
    name: 'tank_product_authorization_id',
    type: 'char',
    length: 36,
  })
  id: string;

  @Column({ name: 'tank_id', type: 'char', length: 36 })
  tankId: string;

  @Column({ name: 'category_id', type: 'char', length: 36, nullable: true })
  categoryId: string | null;

  @Column({ name: 'product_id', type: 'char', length: 36, nullable: true })
  productId: string | null;

  @Column({ name: 'allowed', type: 'boolean', default: true })
  allowed: boolean;

  @Column({ name: 'authorization_type', type: 'varchar', length: 20 })
  authorizationType: string;

  @Column({ name: 'restriction_notes', type: 'text', nullable: true })
  restrictionNotes: string | null;

  @Column({ name: 'valid_from', type: 'date', nullable: true })
  validFrom: string | null;

  @Column({ name: 'valid_to', type: 'date', nullable: true })
  validTo: string | null;

  @CreateDateColumn({ name: 'created_at', type: 'timestamp' })
  createdAt: Date;

  @UpdateDateColumn({ name: 'updated_at', type: 'timestamp' })
  updatedAt: Date;
}
