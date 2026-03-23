import { Body, Controller, Get, Param, Post, UseGuards } from '@nestjs/common';
import { CurrentUser } from '../../common/decorators/current-user.decorator';
import type { JwtPayload } from '../../common/interfaces/jwt-payload.interface';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { ConversationService } from './conversation.service';
import { SendMessageDto } from './dto/send-message.dto';
import { StartConversationDto } from './dto/start-conversation.dto';

@UseGuards(JwtAuthGuard)
@Controller('conversations')
export class ConversationController {
  constructor(private readonly conversationService: ConversationService) {}

  @Post('start')
  async startConversation(
    @CurrentUser() currentUser: JwtPayload,
    @Body() dto: StartConversationDto,
  ) {
    return this.conversationService.startConversation(currentUser, dto);
  }

  @Post(':id/message')
  async sendMessage(
    @Param('id') id: string,
    @CurrentUser() currentUser: JwtPayload,
    @Body() dto: SendMessageDto,
  ) {
    return this.conversationService.sendMessage(id, currentUser, dto);
  }

  @Get(':id')
  async getConversationById(
    @Param('id') id: string,
    @CurrentUser() currentUser: JwtPayload,
  ) {
    return this.conversationService.getConversationById(id, currentUser);
  }

  @Get(':id/messages')
  async getConversationMessages(
    @Param('id') id: string,
    @CurrentUser() currentUser: JwtPayload,
  ) {
    return this.conversationService.getConversationMessages(id, currentUser);
  }
}
