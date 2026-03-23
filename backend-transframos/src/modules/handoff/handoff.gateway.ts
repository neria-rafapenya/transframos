import {
  ConnectedSocket,
  MessageBody,
  SubscribeMessage,
  WebSocketGateway,
  WebSocketServer,
  OnGatewayInit,
  OnGatewayConnection,
  OnGatewayDisconnect,
} from '@nestjs/websockets';
import type { Server, Socket } from 'socket.io';
import { HandoffService } from './handoff.service';

type HandoffStartPayload = {
  sessionId: string;
  userId?: string;
  userName?: string;
  userEmail?: string;
};

type HandoffMessagePayload = {
  sessionId: string;
  text: string;
  sender?: string;
  senderEmail?: string;
};

@WebSocketGateway(Number(process.env.HANDOFF_SOCKET_PORT ?? 5000), {
  namespace: '/handoff',
  cors: {
    origin: true,
    credentials: true,
  },
  transports: ['websocket'],
})
export class HandoffGateway
  implements OnGatewayInit, OnGatewayConnection, OnGatewayDisconnect
{
  @WebSocketServer()
  server: Server;

  constructor(
    private readonly handoffService: HandoffService,
  ) {}

  afterInit(server: Server) {
    this.handoffService.setServer(server);
  }

  handleConnection(client: Socket) {
    this.handoffService.registerSocket(client.id);
  }

  handleDisconnect(client: Socket) {
    this.handoffService.unregisterSocket(client.id);
  }

  @SubscribeMessage('handoff:start')
  async handleStart(
    @ConnectedSocket() client: Socket,
    @MessageBody() payload: HandoffStartPayload,
  ) {
    if (!payload?.sessionId) {
      return;
    }

    client.join(payload.sessionId);
    this.handoffService.registerSession(client.id, payload);

    this.server.to(payload.sessionId).emit('handoff:status', {
      status: 'waiting',
      sessionId: payload.sessionId,
    });
  }

  @SubscribeMessage('handoff:message')
  async handleMessage(
    @ConnectedSocket() client: Socket,
    @MessageBody() payload: HandoffMessagePayload,
  ) {
    if (!payload?.sessionId || !payload?.text) {
      return;
    }

    const safeText = payload.text.trim();
    if (!safeText) {
      return;
    }

    await this.handoffService.forwardUserMessage({
      sessionId: payload.sessionId,
      text: safeText,
      sender: payload.sender,
      senderEmail: payload.senderEmail,
      socketId: client.id,
    });

    this.server.to(payload.sessionId).emit('handoff:message', {
      source: 'user',
      sender: 'user',
      senderName: payload.sender,
      senderEmail: payload.senderEmail,
      text: safeText,
      createdAt: new Date().toISOString(),
    });
  }

  @SubscribeMessage('handoff:close')
  async handleClose(
    @ConnectedSocket() client: Socket,
    @MessageBody() payload: { sessionId: string },
  ) {
    if (!payload?.sessionId) {
      return;
    }

    await this.handoffService.notifyTelegramClose(payload.sessionId);
    this.handoffService.closeSession(payload.sessionId);
    this.server.to(payload.sessionId).emit('handoff:status', {
      status: 'closed',
      sessionId: payload.sessionId,
    });
    client.leave(payload.sessionId);
  }
}
