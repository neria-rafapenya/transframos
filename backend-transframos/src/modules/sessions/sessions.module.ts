import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { AuthSession } from './entities/auth-session.entity';
import { SessionsService } from './sessions.service';
import { SessionsRepository } from './repositories/sessions.repository';

@Module({
  imports: [TypeOrmModule.forFeature([AuthSession])],
  providers: [SessionsService, SessionsRepository],
  exports: [SessionsService, SessionsRepository],
})
export class SessionsModule {}
