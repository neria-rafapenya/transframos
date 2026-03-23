import { Transform } from 'class-transformer';
import { IsEmail, IsOptional, IsString, MinLength } from 'class-validator';

export class RegisterDto {
  @IsEmail()
  email!: string;

  @IsString()
  @MinLength(6)
  password!: string;

  @IsOptional()
  @IsString()
  @MinLength(2)
  @Transform(({ value }) =>
    typeof value === 'string' && value.trim().length === 0 ? undefined : value,
  )
  fullName?: string;
}
