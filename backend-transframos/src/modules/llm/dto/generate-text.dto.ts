import { IsOptional, IsString, MinLength } from 'class-validator';

export class GenerateTextDto {
  @IsString()
  @MinLength(1)
  prompt!: string;

  @IsOptional()
  @IsString()
  actionType?: string;
}
