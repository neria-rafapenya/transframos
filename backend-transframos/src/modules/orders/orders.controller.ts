import { Body, Controller, Get, Param, Patch, Post, Query, UseGuards } from '@nestjs/common';
import { CurrentUser } from '../../common/decorators/current-user.decorator';
import type { JwtPayload } from '../../common/interfaces/jwt-payload.interface';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { CreateDraftOrderDto } from './dto/create-draft-order.dto';
import { OrdersService } from './orders.service';

@Controller('orders')
export class OrdersController {
  constructor(private readonly ordersService: OrdersService) {}

  @UseGuards(JwtAuthGuard)
  @Get()
  async getOrders(
    @CurrentUser() currentUser: JwtPayload,
    @Query('limit') limit?: string,
  ) {
    const parsedLimit = limit ? Number(limit) : undefined;
    return this.ordersService.getOrdersForUser(
      String(currentUser.sub),
      Number.isFinite(parsedLimit ?? NaN) ? (parsedLimit as number) : 50,
    );
  }

  @Post('drafts')
  async createDraftOrder(@Body() dto: CreateDraftOrderDto) {
    return this.ordersService.createDraftOrder(dto);
  }

  @Get('drafts/:id')
  async getDraftOrderById(@Param('id') id: string) {
    return this.ordersService.getDraftOrderById(id);
  }

  @Get('quotes/:quoteRequestId/drafts')
  async getDraftOrdersByQuoteRequestId(
    @Param('quoteRequestId') quoteRequestId: string,
  ) {
    return this.ordersService.getDraftOrdersByQuoteRequestId(quoteRequestId);
  }

  @Patch('drafts/:id/status')
  async updateDraftOrderStatus(
    @Param('id') id: string,
    @Body() body: { status: string },
  ) {
    return this.ordersService.updateDraftOrderStatus(id, body.status);
  }

  @UseGuards(JwtAuthGuard)
  @Get(':id')
  async getOrderById(
    @CurrentUser() currentUser: JwtPayload,
    @Param('id') id: string,
  ) {
    return this.ordersService.getOrderByIdForUser(String(currentUser.sub), id);
  }
}
