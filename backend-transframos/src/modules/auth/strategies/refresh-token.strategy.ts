import { Injectable, UnauthorizedException } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { PassportStrategy } from '@nestjs/passport';
import { Strategy } from 'passport-jwt';
import type { Request } from 'express';
import type { JwtPayload } from '../../../common/interfaces/jwt-payload.interface';
import { UsersService } from '../../users/users.service';

function extractRefreshToken(request: Request): string | null {
  const cookieName =
    process.env.COOKIE_REFRESH_TOKEN_NAME ?? 'tra_refresh_token';

  const token = request.cookies?.[cookieName] as string | undefined;
  return token ?? null;
}

@Injectable()
export class RefreshTokenStrategy extends PassportStrategy(
  Strategy,
  'jwt-refresh',
) {
  constructor(
    configService: ConfigService,
    private readonly usersService: UsersService,
  ) {
    const jwtRefreshSecret = configService.get<string>('JWT_REFRESH_SECRET');

    if (!jwtRefreshSecret) {
      throw new Error('JWT_REFRESH_SECRET no está definido');
    }

    super({
      jwtFromRequest: extractRefreshToken,
      secretOrKey: jwtRefreshSecret,
      passReqToCallback: false,
      ignoreExpiration: false,
    });
  }

  async validate(payload: JwtPayload): Promise<JwtPayload> {
    if (payload.tokenType !== 'refresh') {
      throw new UnauthorizedException('Tipo de token inválido');
    }

    await this.usersService.findActiveUserById(payload.sub);
    return payload;
  }
}
