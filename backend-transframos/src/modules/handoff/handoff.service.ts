import { Injectable, Logger, OnModuleDestroy, OnModuleInit } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import type { Server } from 'socket.io';

type RegisteredSession = {
  sessionId: string;
  userId?: string;
  userName?: string;
  userEmail?: string;
  socketId: string;
  startedAt: string;
};

type ForwardMessageParams = {
  sessionId: string;
  text: string;
  sender?: string;
  senderEmail?: string;
  socketId: string;
};

@Injectable()
export class HandoffService implements OnModuleInit, OnModuleDestroy {
  private readonly logger = new Logger(HandoffService.name);
  private server: Server | null = null;
  private sessions = new Map<string, RegisteredSession>();
  private sessionsById = new Map<string, RegisteredSession>();
  private notifiedSessions = new Set<string>();
  private lastSessionId: string | null = null;
  private pollingActive = false;
  private pollingTimer: NodeJS.Timeout | null = null;
  private pollingOffset: number | null = null;

  constructor(private readonly configService: ConfigService) {}

  async onModuleInit() {
    const pollingEnabled = this.getEnvBoolean('TELEGRAM_POLLING_ENABLED');
    if (!pollingEnabled) {
      return;
    }

    const token = this.configService.get<string>('TELEGRAM_BOT_TOKEN');
    const allowedChatIds = this.getAllowedChatIds();

    if (!token || allowedChatIds.length === 0) {
      this.logger.warn(
        'Telegram polling habilitado pero faltan TELEGRAM_BOT_TOKEN o TELEGRAM_CHAT_ID(S).',
      );
      return;
    }

    await this.startTelegramPolling();
  }

  onModuleDestroy() {
    this.stopTelegramPolling();
  }

  setServer(server: Server) {
    this.server = server;
  }

  registerSocket(socketId: string) {
    if (!this.sessions.has(socketId)) {
      this.sessions.set(socketId, {
        sessionId: '',
        socketId,
        startedAt: new Date().toISOString(),
      });
    }
  }

  unregisterSocket(socketId: string) {
    const existing = this.sessions.get(socketId);
    this.sessions.delete(socketId);
    if (existing?.sessionId) {
      this.sessionsById.delete(existing.sessionId);
    }
  }

  registerSession(
    socketId: string,
    payload: {
      sessionId: string;
      userId?: string;
      userName?: string;
      userEmail?: string;
    },
  ) {
    const session: RegisteredSession = {
      sessionId: payload.sessionId,
      userId: payload.userId,
      userName: payload.userName,
      userEmail: payload.userEmail,
      socketId,
      startedAt: new Date().toISOString(),
    };

    this.sessions.set(socketId, session);
    this.sessionsById.set(payload.sessionId, session);
    this.lastSessionId = payload.sessionId;
  }

  async notifyTelegramStart(payload: {
    sessionId: string;
    userId?: string;
    userName?: string;
    userEmail?: string;
  }) {
    const labelParts = [
      payload.userName ?? payload.userId ?? 'Cliente',
      payload.userEmail ? `<${payload.userEmail}>` : null,
    ].filter(Boolean);

    const message =
      `📨 Nueva solicitud de humano\n` +
      `Usuario: ${labelParts.join(' ')}\n` +
      `Responde y se enviará a la última sesión activa.\n` +
      `Para cerrar la conversación escribe: /cerrar`;
    await this.sendTelegramMessage(message);
  }

  async forwardUserMessage(params: ForwardMessageParams) {
    const sessionInfo = this.sessionsById.get(params.sessionId);
    if (!this.notifiedSessions.has(params.sessionId)) {
      await this.notifyTelegramStart({
        sessionId: params.sessionId,
        userId: sessionInfo?.userId,
        userName: sessionInfo?.userName ?? params.sender,
        userEmail: sessionInfo?.userEmail ?? params.senderEmail,
      });
      this.notifiedSessions.add(params.sessionId);
    }

    const senderLabelParts = [
      sessionInfo?.userName ?? params.sender ?? 'Cliente',
      sessionInfo?.userEmail ?? params.senderEmail
        ? `<${sessionInfo?.userEmail ?? params.senderEmail}>`
        : null,
    ].filter(Boolean);

    const message = `💬 ${senderLabelParts.join(' ')}: ${params.text}`;
    await this.sendTelegramMessage(message);
    this.lastSessionId = params.sessionId;
  }

  async notifyTelegramClose(sessionId: string) {
    const message = `✅ Conversación cerrada. Sesión: ${sessionId}`;
    await this.sendTelegramMessage(message);
    this.closeSession(sessionId);
  }

  async handleTelegramText(
    text: string,
    from?: string,
    chatId?: string | number | null,
  ) {
    if (chatId !== undefined && !this.isAllowedChatId(chatId)) {
      this.logger.warn('Mensaje de Telegram ignorado (chat no autorizado).');
      return;
    }

    const command = text.trim().toLowerCase();
    if (command === '/cerrar' || command === 'cerrar' || command === 'finalizar') {
      await this.closeLatestSessionFromTelegram();
      return;
    }

    const sessionId = this.extractSessionId(text) ?? this.lastSessionId;
    if (!sessionId) {
      this.logger.warn('Mensaje de Telegram sin sesión asociada.');
      return;
    }

    const cleaned = this.stripSessionPrefix(text, sessionId);
    if (!cleaned.trim()) {
      return;
    }

    this.server?.to(sessionId).emit('handoff:status', {
      status: 'connected',
      sessionId,
    });

    this.server?.to(sessionId).emit('handoff:message', {
      source: 'telegram',
      sender: from ?? 'humano',
      text: cleaned.trim(),
      createdAt: new Date().toISOString(),
    });
  }

  private async closeLatestSessionFromTelegram() {
    if (!this.lastSessionId) {
      await this.sendTelegramMessage('No hay ninguna sesión activa.');
      return;
    }

    this.server?.to(this.lastSessionId).emit('handoff:status', {
      status: 'closed',
      sessionId: this.lastSessionId,
    });

    await this.sendTelegramMessage(
      `✅ Conversación cerrada (sesión ${this.lastSessionId}).`,
    );
    this.closeSession(this.lastSessionId);
  }

  closeSession(sessionId: string) {
    if (this.lastSessionId === sessionId) {
      this.lastSessionId = null;
    }

    this.sessionsById.delete(sessionId);
    this.notifiedSessions.delete(sessionId);

    for (const [socketId, session] of this.sessions.entries()) {
      if (session.sessionId === sessionId) {
        this.sessions.delete(socketId);
      }
    }
  }

  private extractSessionId(text: string): string | null {
    const match = text.match(
      /[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}/,
    );
    if (match) {
      return match[0];
    }

    const numericMatch = text.trim().match(/^(\d{1,10})\b/);
    return numericMatch ? numericMatch[1] : null;
  }

  private stripSessionPrefix(text: string, sessionId: string): string {
    return text.replace(sessionId, '').replace(/^[\s:-]+/, '');
  }

  private async sendTelegramMessage(text: string) {
    const token = this.configService.get<string>('TELEGRAM_BOT_TOKEN');
    const chatIds = this.getAllowedChatIds();

    if (!token || chatIds.length === 0) {
      return;
    }

    for (const chatId of chatIds) {
      try {
        const response = await fetch(
          `https://api.telegram.org/bot${token}/sendMessage`,
          {
            method: 'POST',
            headers: {
              'Content-Type': 'application/json',
            },
            body: JSON.stringify({
              chat_id: chatId,
              text,
            }),
          },
        );

        if (!response.ok) {
          const payload = await response.text();
          this.logger.warn(`Telegram error: ${payload}`);
        }
      } catch (error) {
        this.logger.warn(`Telegram error: ${String(error)}`);
      }
    }
  }

  private async startTelegramPolling() {
    if (this.pollingActive) {
      return;
    }

    this.pollingActive = true;
    await this.deleteTelegramWebhook();
    this.scheduleNextPoll(0);
  }

  private stopTelegramPolling() {
    this.pollingActive = false;
    if (this.pollingTimer) {
      clearTimeout(this.pollingTimer);
      this.pollingTimer = null;
    }
  }

  private scheduleNextPoll(delayMs: number) {
    if (!this.pollingActive) {
      return;
    }

    if (this.pollingTimer) {
      clearTimeout(this.pollingTimer);
    }

    this.pollingTimer = setTimeout(() => {
      void this.pollTelegramUpdates();
    }, delayMs);
  }

  private async pollTelegramUpdates() {
    if (!this.pollingActive) {
      return;
    }

    const token = this.configService.get<string>('TELEGRAM_BOT_TOKEN');
    const allowedChatIds = this.getAllowedChatIds();
    if (!token || allowedChatIds.length === 0) {
      this.scheduleNextPoll(5000);
      return;
    }

    const timeoutSeconds =
      this.configService.get<string>('TELEGRAM_POLLING_TIMEOUT_SEC') ?? '20';
    const intervalMs =
      Number(this.configService.get<string>('TELEGRAM_POLLING_INTERVAL_MS')) || 1200;

    try {
      const url = new URL(`https://api.telegram.org/bot${token}/getUpdates`);
      url.searchParams.set('timeout', timeoutSeconds);
      url.searchParams.set('allowed_updates', '["message"]');
      if (this.pollingOffset !== null) {
        url.searchParams.set('offset', String(this.pollingOffset));
      }

      const response = await fetch(url.toString());
      if (!response.ok) {
        const text = await response.text();
        this.logger.warn(`Telegram polling error: ${text}`);
        this.scheduleNextPoll(3000);
        return;
      }

      const payload = (await response.json()) as {
        ok: boolean;
        result?: Array<{
          update_id: number;
          message?: {
            text?: string;
            chat?: { id?: number | string };
            from?: {
              first_name?: string;
              last_name?: string;
              username?: string;
            };
          };
        }>;
      };

      if (!payload.ok || !Array.isArray(payload.result)) {
        this.scheduleNextPoll(intervalMs);
        return;
      }

      let maxUpdateId: number | null = null;
      for (const update of payload.result) {
        if (!update) {
          continue;
        }
        maxUpdateId = Math.max(maxUpdateId ?? 0, update.update_id);

        const message = update.message;
        const text = message?.text;
        if (!text) {
          continue;
        }

        if (!this.isAllowedChatId(message?.chat?.id ?? null)) {
          continue;
        }

        const from = message?.from;
        const fromLabel = from
          ? `${from.first_name ?? ''} ${from.last_name ?? ''}`.trim() ||
            from.username
          : undefined;

        await this.handleTelegramText(text, fromLabel, message?.chat?.id ?? null);
      }

      if (maxUpdateId !== null) {
        this.pollingOffset = maxUpdateId + 1;
      }
    } catch (error) {
      this.logger.warn(`Telegram polling error: ${String(error)}`);
      this.scheduleNextPoll(3000);
      return;
    }

    this.scheduleNextPoll(intervalMs);
  }

  private async deleteTelegramWebhook() {
    const token = this.configService.get<string>('TELEGRAM_BOT_TOKEN');
    if (!token) {
      return;
    }

    try {
      const response = await fetch(
        `https://api.telegram.org/bot${token}/deleteWebhook`,
        {
          method: 'POST',
          headers: {
            'Content-Type': 'application/json',
          },
          body: JSON.stringify({ drop_pending_updates: false }),
        },
      );

      if (!response.ok) {
        const text = await response.text();
        this.logger.warn(`Telegram deleteWebhook error: ${text}`);
      }
    } catch (error) {
      this.logger.warn(`Telegram deleteWebhook error: ${String(error)}`);
    }
  }

  private getEnvBoolean(key: string): boolean {
    const raw = this.configService.get<string>(key);
    if (!raw) {
      return false;
    }
    const normalized = raw
      .trim()
      .replace(/^['"]+|['"]+$/g, '')
      .toLowerCase();
    return ['true', '1', 'yes', 'y'].includes(normalized);
  }

  private getAllowedChatIds(): string[] {
    const rawList = this.configService.get<string>('TELEGRAM_CHAT_IDS');
    const fallback = this.configService.get<string>('TELEGRAM_CHAT_ID');
    const source = rawList && rawList.trim().length > 0 ? rawList : fallback;
    if (!source) {
      return [];
    }
    const tokens = source
      .split(/[,\s]+/)
      .map((item) => item.trim())
      .filter(Boolean);
    return Array.from(new Set(tokens));
  }

  private isAllowedChatId(chatId: string | number | null | undefined): boolean {
    if (chatId === null || typeof chatId === 'undefined') {
      return false;
    }
    const allowed = this.getAllowedChatIds();
    if (allowed.length === 0) {
      return false;
    }
    return allowed.includes(String(chatId));
  }
}
