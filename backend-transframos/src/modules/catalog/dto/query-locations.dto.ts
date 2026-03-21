import { Transform } from 'class-transformer';
import { IsBoolean, IsIn, IsOptional, IsString, Length } from 'class-validator';

export class QueryLocationsDto {
  @IsOptional()
  @IsString()
  search?: string;

  @IsOptional()
  @IsString()
  province?: string;

  @IsOptional()
  @IsString()
  @Length(2, 2)
  countryCode?: string;

  @IsOptional()
  @IsString()
  @IsIn(['loading', 'unloading'])
  pointType?: 'loading' | 'unloading';

  @IsOptional()
  @Transform(({ value }) => {
    if (value === '' || value === null || typeof value === 'undefined') {
      return undefined;
    }

    if (typeof value === 'boolean') {
      return value;
    }

    return value === 'true';
  })
  @IsBoolean()
  isActive?: boolean;
}
