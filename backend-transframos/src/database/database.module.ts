import { Module } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { TypeOrmModule } from '@nestjs/typeorm';
import { User } from '../modules/users/entities/user.entity';
import { AuthSession } from '../modules/sessions/entities/auth-session.entity';
import { LlmAction } from '../modules/llm/entities/llm-action.entity';

@Module({
  imports: [
    TypeOrmModule.forRootAsync({
      inject: [ConfigService],
      useFactory: (configService: ConfigService) => ({
        type: 'mysql' as const,
        host: configService.get<string>('DB_HOST'),
        port: Number(configService.get<string>('DB_PORT')),
        username: configService.get<string>('DB_USERNAME'),
        password: configService.get<string>('DB_PASSWORD'),
        database: configService.get<string>('DB_NAME'),
        entities: [User, AuthSession, LlmAction],
        entityPrefix: 'tra_',
        synchronize: false,
        logging: false,
      }),
    }),
  ],
})
export class DatabaseModule {}
