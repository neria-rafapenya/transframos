import { Body, Controller, Get, Post, Req, UseGuards } from '@nestjs/common';
import type { Request } from 'express';
import { CurrentUser } from '../../common/decorators/current-user.decorator';
import type { JwtPayload } from '../../common/interfaces/jwt-payload.interface';
import { LoginDto } from './dto/login.dto';
import { LogoutDto } from './dto/logout.dto';
import { RefreshTokenDto } from './dto/refresh-token.dto';
import { AuthService } from './auth.service';
import { JwtAuthGuard } from './guards/jwt-auth.guard';
import { RefreshTokenGuard } from './guards/refresh-token.guard';

@Controller('auth')
export class AuthController {
  constructor(private readonly authService: AuthService) {}

  @Post('login')
  login(@Body() dto: LoginDto, @Req() request: Request) {
    return this.authService.login(
      dto,
      request.ip,
      request.get('user-agent') ?? undefined,
    );
  }

  @Post('refresh')
  @UseGuards(RefreshTokenGuard)
  refresh(@CurrentUser() payload: JwtPayload, @Body() dto: RefreshTokenDto) {
    return this.authService.refresh(payload, dto);
  }

  @Post('logout')
  @UseGuards(JwtAuthGuard)
  logout(@CurrentUser() payload: JwtPayload, @Body() dto: LogoutDto) {
    return this.authService.logout(payload, dto);
  }

  @Get('me')
  @UseGuards(JwtAuthGuard)
  me(@CurrentUser() payload: JwtPayload) {
    return this.authService.me(payload);
  }
}
