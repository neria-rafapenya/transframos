import { Injectable, UnauthorizedException } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { PassportStrategy } from '@nestjs/passport';
import { Strategy } from 'passport-jwt';
import type { Request } from 'express';
import type { JwtPayload } from '../../../common/interfaces/jwt-payload.interface';
import { UsersService } from '../../users/users.service';

function extractAccessTokenFromCookie(request: Request): string | null {
  const cookieName = process.env.COOKIE_ACCESS_TOKEN_NAME ?? 'tra_access_token';
  const token = request.cookies?.[cookieName] as string | undefined;
  return token ?? null;
}

@Injectable()
export class JwtStrategy extends PassportStrategy(Strategy, 'jwt') {
  constructor(
    configService: ConfigService,
    private readonly usersService: UsersService,
  ) {
    const jwtAccessSecret = configService.get<string>('JWT_ACCESS_SECRET');

    if (!jwtAccessSecret) {
      throw new Error('JWT_ACCESS_SECRET no está definido');
    }

    super({
      jwtFromRequest: extractAccessTokenFromCookie,
      secretOrKey: jwtAccessSecret,
      ignoreExpiration: false,
    });
  }

  async validate(payload: JwtPayload): Promise<JwtPayload> {
    if (payload.tokenType !== 'access') {
      throw new UnauthorizedException('Tipo de token inválido');
    }

    await this.usersService.findActiveUserById(payload.sub);
    return payload;
  }
}
