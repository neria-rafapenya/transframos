import type { UserRole } from '../../../common/enums/user-role.enum';
import type { ClientType } from '../../../common/enums/client-type.enum';

export class UserResponseDto {
  id!: string;
  email!: string;
  fullName!: string;
  role!: UserRole;
  clientType!: ClientType;
  clientId!: string | null;
  isActive!: boolean;
  dni!: string | null;
  nif!: string | null;
  companyName!: string | null;
  companyHqAddress!: string | null;
  contactName!: string | null;
  contactPhone!: string | null;
  contactPhoneAlt!: string | null;
  contactEmail!: string | null;
  createdAt!: Date;
  updatedAt!: Date;
}
