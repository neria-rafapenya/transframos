import { Injectable, UnauthorizedException } from '@nestjs/common';
import * as bcrypt from 'bcrypt';
import { CreateSessionDto } from './dto/create-session.dto';
import { AuthSession } from './entities/auth-session.entity';
import { SessionsRepository } from './repositories/sessions.repository';

@Injectable()
export class SessionsService {
  constructor(private readonly sessionsRepository: SessionsRepository) {}

  async createSession(dto: CreateSessionDto): Promise<AuthSession> {
    const session = this.sessionsRepository.create({
      userId: dto.userId,
      ipAddress: dto.ipAddress ?? null,
      userAgent: dto.userAgent ?? null,
      isRevoked: false,
      accessTokenJti: null,
      refreshTokenHash: null,
      expiresAt: null,
    });

    return this.sessionsRepository.save(session);
  }

  findById(id: string): Promise<AuthSession | null> {
    return this.sessionsRepository.findById(id);
  }

  async attachTokens(
    sessionId: string,
    accessTokenJti: string,
    refreshToken: string,
    refreshExpiresAt: Date,
  ): Promise<AuthSession> {
    const session = await this.findOrFail(sessionId);

    session.accessTokenJti = accessTokenJti;
    session.refreshTokenHash = await bcrypt.hash(refreshToken, 10);
    session.expiresAt = refreshExpiresAt;
    session.isRevoked = false;

    return this.sessionsRepository.save(session);
  }

  async rotateRefreshToken(
    sessionId: string,
    accessTokenJti: string,
    refreshToken: string,
    refreshExpiresAt: Date,
  ): Promise<AuthSession> {
    return this.attachTokens(
      sessionId,
      accessTokenJti,
      refreshToken,
      refreshExpiresAt,
    );
  }

  async validateRefreshToken(
    sessionId: string,
    refreshToken: string,
  ): Promise<AuthSession> {
    const session = await this.findOrFail(sessionId);

    if (session.isRevoked) {
      throw new UnauthorizedException('La sesión está revocada');
    }

    if (!session.refreshTokenHash) {
      throw new UnauthorizedException(
        'No hay refresh token activo en la sesión',
      );
    }

    if (session.expiresAt && session.expiresAt.getTime() < Date.now()) {
      throw new UnauthorizedException('El refresh token ha expirado');
    }

    const isValid = await bcrypt.compare(
      refreshToken,
      session.refreshTokenHash,
    );

    if (!isValid) {
      throw new UnauthorizedException('Refresh token inválido');
    }

    return session;
  }

  async revokeSession(sessionId: string): Promise<void> {
    const session = await this.findOrFail(sessionId);

    session.isRevoked = true;
    session.refreshTokenHash = null;

    await this.sessionsRepository.save(session);
  }

  async revokeAllUserSessions(userId: string): Promise<void> {
    await this.sessionsRepository.revokeByUserId(userId);
  }

  private async findOrFail(id: string): Promise<AuthSession> {
    const session = await this.sessionsRepository.findById(id);

    if (!session) {
      throw new UnauthorizedException('Sesión no encontrada');
    }

    return session;
  }
}
