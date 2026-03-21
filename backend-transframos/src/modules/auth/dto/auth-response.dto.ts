import type { UserRole } from '../../../common/enums/user-role.enum';

export class AuthResponseDto {
  sessionId!: string;
  user!: {
    id: string;
    email: string;
    fullName: string;
    role: UserRole;
  };
}
