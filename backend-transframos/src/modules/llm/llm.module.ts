import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { ConfigService } from '@nestjs/config';
import { LlmController } from './llm.controller';
import { LlmService } from './llm.service';
import { LlmActionsRepository } from './repositories/llm-actions.repository';
import { LlmAction } from './entities/llm-action.entity';
import { LLM_PROVIDER_TOKEN } from './constants/llm.constants';
import { OpenAiProvider } from './providers/openai.provider';

@Module({
  imports: [TypeOrmModule.forFeature([LlmAction])],
  controllers: [LlmController],
  providers: [
    LlmService,
    LlmActionsRepository,
    {
      provide: LLM_PROVIDER_TOKEN,
      inject: [ConfigService],
      useFactory: (configService: ConfigService) => {
        const provider = configService.get<string>('LLM_PROVIDER') ?? 'openai';

        return new OpenAiProvider(configService);
      },
    },
  ],
  exports: [LlmService],
})
export class LlmModule {}
