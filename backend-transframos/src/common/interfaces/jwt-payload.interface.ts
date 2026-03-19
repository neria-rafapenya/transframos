import { UserRole } from '../enums/user-role.enum';

export interface JwtPayload {
  sub: string;
  email: string;
  role: UserRole;
  sessionId: string;
  tokenType: 'access' | 'refresh';
  jti: string;
}
