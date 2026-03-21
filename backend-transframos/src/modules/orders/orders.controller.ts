import { Body, Controller, Get, Param, Patch, Post } from '@nestjs/common';
import { CreateDraftOrderDto } from './dto/create-draft-order.dto';
import { OrdersService } from './orders.service';

@Controller('orders')
export class OrdersController {
  constructor(private readonly ordersService: OrdersService) {}

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
}
