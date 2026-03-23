import { Module } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
import { HandoffGateway } from './handoff.gateway';
import { HandoffService } from './handoff.service';
import { TelegramController } from './telegram.controller';

@Module({
  imports: [ConfigModule],
  providers: [HandoffGateway, HandoffService],
  controllers: [TelegramController],
  exports: [HandoffService],
})
export class HandoffModule {}
