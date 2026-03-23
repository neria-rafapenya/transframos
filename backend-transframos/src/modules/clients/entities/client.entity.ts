import {
  Column,
  CreateDateColumn,
  Entity,
  PrimaryColumn,
  UpdateDateColumn,
} from 'typeorm';

@Entity({ name: 'tra_clients' })
export class ClientEntity {
  @PrimaryColumn({ name: 'client_id', type: 'char', length: 36 })
  id: string;

  @Column({ name: 'client_code', type: 'varchar', length: 30 })
  code: string;

  @Column({ name: 'legal_name', type: 'varchar', length: 200 })
  legalName: string;

  @Column({ name: 'trade_name', type: 'varchar', length: 150, nullable: true })
  tradeName: string | null;

  @Column({ name: 'vat_number', type: 'varchar', length: 30, nullable: true })
  vatNumber: string | null;

  @Column({ name: 'country_code', type: 'char', length: 2 })
  countryCode: string;

  @Column({ name: 'status', type: 'varchar', length: 20 })
  status: string;

  @Column({ name: 'client_type', type: 'varchar', length: 20 })
  clientType: string;

  @Column({ name: 'primary_sector', type: 'varchar', length: 30 })
  primarySector: string;

  @Column({ name: 'sla_tier', type: 'varchar', length: 20, nullable: true })
  slaTier: string | null;

  @Column({ name: 'payment_terms_days', type: 'int', nullable: true })
  paymentTermsDays: number | null;

  @Column({
    name: 'preferred_language',
    type: 'varchar',
    length: 10,
    nullable: true,
  })
  preferredLanguage: string | null;

  @CreateDateColumn({ name: 'created_at', type: 'timestamp' })
  createdAt: Date;

  @UpdateDateColumn({ name: 'updated_at', type: 'timestamp' })
  updatedAt: Date;

  @Column({ name: 'notes', type: 'text', nullable: true })
  notes: string | null;
}
