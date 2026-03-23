import type { UserRole } from '../../../common/enums/user-role.enum';
import type { ClientType } from '../../../common/enums/client-type.enum';

export class AuthResponseDto {
  sessionId!: string;
  user!: {
    id: string;
    email: string;
    fullName: string;
    role: UserRole;
    clientType: ClientType;
  };
}
