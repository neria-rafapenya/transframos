import {
  Column,
  CreateDateColumn,
  Entity,
  OneToMany,
  PrimaryGeneratedColumn,
  UpdateDateColumn,
} from 'typeorm';
import { ClientType } from '../../../common/enums/client-type.enum';
import { UserRole } from '../../../common/enums/user-role.enum';
import { AuthSession } from '../../sessions/entities/auth-session.entity';
import { LlmAction } from '../../llm/entities/llm-action.entity';

@Entity({ name: 'tra_users' })
export class User {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column({ name: 'email', type: 'varchar', length: 255, unique: true })
  email: string;

  @Column({ name: 'password_hash', type: 'varchar', length: 255 })
  passwordHash: string;

  @Column({ name: 'full_name', type: 'varchar', length: 255 })
  fullName: string;

  @Column({ name: 'dni', type: 'varchar', length: 20, nullable: true })
  dni: string | null;

  @Column({ name: 'nif', type: 'varchar', length: 20, nullable: true })
  nif: string | null;

  @Column({ name: 'company_name', type: 'varchar', length: 255, nullable: true })
  companyName: string | null;

  @Column({
    name: 'company_hq_address',
    type: 'varchar',
    length: 255,
    nullable: true,
  })
  companyHqAddress: string | null;

  @Column({ name: 'contact_name', type: 'varchar', length: 255, nullable: true })
  contactName: string | null;

  @Column({ name: 'contact_phone', type: 'varchar', length: 40, nullable: true })
  contactPhone: string | null;

  @Column({
    name: 'contact_phone_alt',
    type: 'varchar',
    length: 40,
    nullable: true,
  })
  contactPhoneAlt: string | null;

  @Column({
    name: 'contact_email',
    type: 'varchar',
    length: 255,
    nullable: true,
  })
  contactEmail: string | null;

  @Column({
    name: 'role',
    type: 'enum',
    enum: UserRole,
  })
  role: UserRole;

  @Column({
    name: 'client_type',
    type: 'enum',
    enum: ClientType,
    default: ClientType.FIDELIZADO,
  })
  clientType: ClientType;

  @Column({ name: 'client_id', type: 'char', length: 36, nullable: true })
  clientId: string | null;

  @Column({ name: 'is_active', type: 'boolean', default: true })
  isActive: boolean;

  @CreateDateColumn({ name: 'created_at', type: 'datetime' })
  createdAt: Date;

  @UpdateDateColumn({ name: 'updated_at', type: 'datetime' })
  updatedAt: Date;

  @OneToMany(() => AuthSession, (session) => session.user)
  sessions: AuthSession[];

  @OneToMany(() => LlmAction, (llmAction) => llmAction.user)
  llmActions: LlmAction[];
}
