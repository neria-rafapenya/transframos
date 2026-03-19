export class CreateSessionDto {
  userId!: string;
  ipAddress?: string | null;
  userAgent?: string | null;
}
