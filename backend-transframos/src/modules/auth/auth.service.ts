import { Injectable } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { JwtService, type JwtSignOptions } from '@nestjs/jwt';
import { randomUUID } from 'crypto';
import * as ms from 'ms';
import type { JwtPayload } from '../../common/interfaces/jwt-payload.interface';
import { LogoutDto } from './dto/logout.dto';
import { LoginDto } from './dto/login.dto';
import { RefreshTokenDto } from './dto/refresh-token.dto';
import { AuthResponseDto } from './dto/auth-response.dto';
import { RegisterDto } from './dto/register.dto';
import { SessionsService } from '../sessions/sessions.service';
import { UsersService } from '../users/users.service';
import { User } from '../users/entities/user.entity';

@Injectable()
export class AuthService {
  constructor(
    private readonly usersService: UsersService,
    private readonly sessionsService: SessionsService,
    private readonly jwtService: JwtService,
    private readonly configService: ConfigService,
  ) {}

  private getRequiredEnv(key: string): string {
    const value = this.configService.get<string>(key);

    if (!value) {
      throw new Error(`${key} no está definido`);
    }

    return value;
  }

  private getAccessSecret(): string {
    return this.getRequiredEnv('JWT_ACCESS_SECRET');
  }

  private getRefreshSecret(): string {
    return this.getRequiredEnv('JWT_REFRESH_SECRET');
  }

  private getAccessExpiresIn(): string {
    return this.configService.get<string>('JWT_ACCESS_EXPIRES_IN') ?? '15m';
  }

  private getRefreshExpiresIn(): string {
    return this.configService.get<string>('JWT_REFRESH_EXPIRES_IN') ?? '7d';
  }

  private getRefreshExpiryDate(): Date {
    const expiresIn = this.getRefreshExpiresIn();
    const milliseconds = ms(expiresIn as ms.StringValue);
    return new Date(Date.now() + milliseconds);
  }

  private buildAccessPayload(
    user: User,
    sessionId: string,
    jti: string,
  ): JwtPayload {
    return {
      sub: user.id,
      email: user.email,
      role: user.role,
      sessionId,
      tokenType: 'access',
      jti,
    };
  }

  private buildRefreshPayload(
    user: User,
    sessionId: string,
    jti: string,
  ): JwtPayload {
    return {
      sub: user.id,
      email: user.email,
      role: user.role,
      sessionId,
      tokenType: 'refresh',
      jti,
    };
  }

  private async signTokens(
    user: User,
    sessionId: string,
  ): Promise<{
    accessToken: string;
    refreshToken: string;
    accessJti: string;
  }> {
    const accessJti = randomUUID();
    const refreshJti = randomUUID();

    const accessPayload = this.buildAccessPayload(user, sessionId, accessJti);
    const refreshPayload = this.buildRefreshPayload(
      user,
      sessionId,
      refreshJti,
    );

    const accessPayloadToSign: Record<string, unknown> = {
      sub: accessPayload.sub,
      email: accessPayload.email,
      role: accessPayload.role,
      sessionId: accessPayload.sessionId,
      tokenType: accessPayload.tokenType,
      jti: accessPayload.jti,
    };

    const refreshPayloadToSign: Record<string, unknown> = {
      sub: refreshPayload.sub,
      email: refreshPayload.email,
      role: refreshPayload.role,
      sessionId: refreshPayload.sessionId,
      tokenType: refreshPayload.tokenType,
      jti: refreshPayload.jti,
    };

    const accessOptions: JwtSignOptions = {
      secret: this.getAccessSecret(),
      expiresIn: this.getAccessExpiresIn() as ms.StringValue,
    };

    const refreshOptions: JwtSignOptions = {
      secret: this.getRefreshSecret(),
      expiresIn: this.getRefreshExpiresIn() as ms.StringValue,
    };

    const accessToken = await this.jwtService.signAsync(
      accessPayloadToSign,
      accessOptions,
    );

    const refreshToken = await this.jwtService.signAsync(
      refreshPayloadToSign,
      refreshOptions,
    );

    return {
      accessToken,
      refreshToken,
      accessJti,
    };
  }

  async login(
    dto: LoginDto,
    ipAddress?: string,
    userAgent?: string,
  ): Promise<AuthResponseDto & { accessToken: string; refreshToken: string }> {
    const user = await this.usersService.validateUser(dto.email, dto.password);

    const session = await this.sessionsService.createSession({
      userId: user.id,
      ipAddress: ipAddress ?? null,
      userAgent: userAgent ?? null,
    });

    const tokens = await this.signTokens(user, session.id);

    await this.sessionsService.attachTokens(
      session.id,
      tokens.accessJti,
      tokens.refreshToken,
      this.getRefreshExpiryDate(),
    );

    return {
      accessToken: tokens.accessToken,
      refreshToken: tokens.refreshToken,
      sessionId: session.id,
      user: this.usersService.toUserResponse(user),
    };
  }

  async register(
    dto: RegisterDto,
    ipAddress?: string,
    userAgent?: string,
  ): Promise<AuthResponseDto & { accessToken: string; refreshToken: string }> {
    const user = await this.usersService.registerClient({
      email: dto.email,
      password: dto.password,
      fullName: dto.fullName ?? '',
    });

    const session = await this.sessionsService.createSession({
      userId: user.id,
      ipAddress: ipAddress ?? null,
      userAgent: userAgent ?? null,
    });

    const tokens = await this.signTokens(user, session.id);

    await this.sessionsService.attachTokens(
      session.id,
      tokens.accessJti,
      tokens.refreshToken,
      this.getRefreshExpiryDate(),
    );

    return {
      accessToken: tokens.accessToken,
      refreshToken: tokens.refreshToken,
      sessionId: session.id,
      user: this.usersService.toUserResponse(user),
    };
  }

  async refresh(
    payload: JwtPayload,
    dto: RefreshTokenDto,
  ): Promise<AuthResponseDto & { accessToken: string; refreshToken: string }> {
    await this.sessionsService.validateRefreshToken(
      payload.sessionId,
      dto.refreshToken,
    );

    const user = await this.usersService.findActiveUserById(payload.sub);
    const tokens = await this.signTokens(user, payload.sessionId);

    await this.sessionsService.rotateRefreshToken(
      payload.sessionId,
      tokens.accessJti,
      tokens.refreshToken,
      this.getRefreshExpiryDate(),
    );

    return {
      accessToken: tokens.accessToken,
      refreshToken: tokens.refreshToken,
      sessionId: payload.sessionId,
      user: this.usersService.toUserResponse(user),
    };
  }

  async logout(
    payload: JwtPayload,
    dto: LogoutDto,
  ): Promise<{ success: true }> {
    if (dto.allDevices) {
      await this.sessionsService.revokeAllUserSessions(payload.sub);
      return { success: true };
    }

    await this.sessionsService.revokeSession(payload.sessionId);
    return { success: true };
  }

  async me(payload: JwtPayload) {
    const user = await this.usersService.findActiveUserById(payload.sub);
    return this.usersService.toUserResponse(user);
  }
}
