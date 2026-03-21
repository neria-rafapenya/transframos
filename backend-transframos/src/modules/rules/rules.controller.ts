import { Body, Controller, Get, Param, Post } from '@nestjs/common';
import { ValidateQuoteDto } from './dto/validate-quote.dto';
import { RulesService } from './rules.service';

@Controller('rules')
export class RulesController {
  constructor(private readonly rulesService: RulesService) {}

  @Post('quotes/:quoteRequestId/validate')
  async validateQuoteRequest(
    @Param('quoteRequestId') quoteRequestId: string,
    @Body() dto: ValidateQuoteDto,
  ) {
    return this.rulesService.validateQuoteRequest(quoteRequestId, dto);
  }

  @Get('quotes/:quoteRequestId/summary')
  async getValidationSummary(@Param('quoteRequestId') quoteRequestId: string) {
    return this.rulesService.getValidationSummary(quoteRequestId);
  }
}
