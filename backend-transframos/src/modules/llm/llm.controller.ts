import { Body, Controller, Post, UseGuards } from '@nestjs/common';
import { CurrentUser } from '../../common/decorators/current-user.decorator';
import type { JwtPayload } from '../../common/interfaces/jwt-payload.interface';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { GenerateTextDto } from './dto/generate-text.dto';
import { LlmService } from './llm.service';

@Controller('llm')
@UseGuards(JwtAuthGuard)
export class LlmController {
  constructor(private readonly llmService: LlmService) {}

  @Post('generate-text')
  generateText(
    @Body() dto: GenerateTextDto,
    @CurrentUser() currentUser: JwtPayload,
  ) {
    return this.llmService.generateText(dto, currentUser.sub);
  }
}
