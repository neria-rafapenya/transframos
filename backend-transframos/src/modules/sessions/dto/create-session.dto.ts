export class CreateSessionDto {
  userId!: string;
  refreshTokenHash?: string | null;
  userAgent?: string | null;
  ipAddress?: string | null;
  expiresAt?: Date | null;
}
