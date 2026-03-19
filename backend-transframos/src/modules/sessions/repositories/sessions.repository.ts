import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { AuthSession } from '../entities/auth-session.entity';

@Injectable()
export class SessionsRepository {
  constructor(
    @InjectRepository(AuthSession)
    private readonly repository: Repository<AuthSession>,
  ) {}

  create(data: Partial<AuthSession>): AuthSession {
    return this.repository.create(data);
  }

  save(session: AuthSession): Promise<AuthSession> {
    return this.repository.save(session);
  }

  findById(id: string): Promise<AuthSession | null> {
    return this.repository.findOne({ where: { id } });
  }

  findByUserId(userId: string): Promise<AuthSession[]> {
    return this.repository.find({ where: { userId } });
  }

  async revokeByUserId(userId: string): Promise<void> {
    await this.repository.update({ userId }, { isRevoked: true });
  }
}
