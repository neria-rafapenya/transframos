import { Body, Controller, ForbiddenException, Param, Post } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { HandoffService } from './handoff.service';

type TelegramUpdate = {
  message?: {
    text?: string;
    chat?: {
      id?: string | number;
    };
    from?: {
      first_name?: string;
      last_name?: string;
      username?: string;
    };
  };
};

@Controller('telegram')
export class TelegramController {
  constructor(
    private readonly handoffService: HandoffService,
    private readonly configService: ConfigService,
  ) {}

  @Post('webhook/:secret')
  async handleWebhook(
    @Param('secret') secret: string,
    @Body() update: TelegramUpdate,
  ) {
    const expected = this.configService.get<string>('TELEGRAM_WEBHOOK_SECRET');

    if (!expected || secret !== expected) {
      throw new ForbiddenException('Webhook no autorizado');
    }

    const text = update?.message?.text;
    if (!text) {
      return { ok: true };
    }

    const from = update.message?.from;
    const fromLabel = from
      ? `${from.first_name ?? ''} ${from.last_name ?? ''}`.trim() ||
        from.username
      : undefined;

    const chatId = update.message?.chat?.id ?? null;
    await this.handoffService.handleTelegramText(text, fromLabel, chatId);

    return { ok: true };
  }
}
