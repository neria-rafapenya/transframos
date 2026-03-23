import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { QuoteController } from './quote.controller';
import { QuoteService } from './quote.service';
import { QuoteRepository } from './repositories/quote.repository';
import { QuoteRequestEntity } from './entities/quote-request.entity';
import { QuoteOptionEntity } from './entities/quote-option.entity';
import { ValidationResultEntity } from './entities/validation-result.entity';

@Module({
  imports: [
    TypeOrmModule.forFeature([
      QuoteRequestEntity,
      QuoteOptionEntity,
      ValidationResultEntity,
    ]),
  ],
  controllers: [QuoteController],
  providers: [QuoteService, QuoteRepository],
  exports: [QuoteService, QuoteRepository],
})
export class QuoteModule {}
