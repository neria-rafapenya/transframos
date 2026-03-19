import { IsBoolean, IsOptional } from 'class-validator';

export class RevokeSessionDto {
  @IsOptional()
  @IsBoolean()
  allDevices?: boolean;
}
