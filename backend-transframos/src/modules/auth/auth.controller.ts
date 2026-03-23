import {
  Body,
  Controller,
  Get,
  Post,
  Req,
  Res,
  UseGuards,
} from '@nestjs/common';
import type { Request, Response } from 'express';
import { CurrentUser } from '../../common/decorators/current-user.decorator';
import type { JwtPayload } from '../../common/interfaces/jwt-payload.interface';
import { LoginDto } from './dto/login.dto';
import { LogoutDto } from './dto/logout.dto';
import { RefreshTokenDto } from './dto/refresh-token.dto';
import { RegisterDto } from './dto/register.dto';
import { AuthService } from './auth.service';
import { JwtAuthGuard } from './guards/jwt-auth.guard';
import { RefreshTokenGuard } from './guards/refresh-token.guard';
import { clearAuthCookies, setAuthCookies } from './auth.cookies';

@Controller('auth')
export class AuthController {
  constructor(private readonly authService: AuthService) {}

  @Post('login')
  async login(
    @Body() dto: LoginDto,
    @Req() request: Request,
    @Res({ passthrough: true }) response: Response,
  ) {
    const result = await this.authService.login(
      dto,
      request.ip,
      request.get('user-agent') ?? undefined,
    );

    setAuthCookies(response, {
      accessToken: result.accessToken,
      refreshToken: result.refreshToken,
    });

    return {
      sessionId: result.sessionId,
      user: result.user,
    };
  }

  @Post('register')
  async register(
    @Body() dto: RegisterDto,
    @Req() request: Request,
    @Res({ passthrough: true }) response: Response,
  ) {
    const result = await this.authService.register(
      dto,
      request.ip,
      request.get('user-agent') ?? undefined,
    );

    setAuthCookies(response, {
      accessToken: result.accessToken,
      refreshToken: result.refreshToken,
    });

    return {
      sessionId: result.sessionId,
      user: result.user,
    };
  }

  @Post('refresh')
  @UseGuards(RefreshTokenGuard)
  async refresh(
    @CurrentUser() payload: JwtPayload,
    @Req() request: Request,
    @Res({ passthrough: true }) response: Response,
  ) {
    const refreshToken =
      (request.cookies?.[
        process.env.COOKIE_REFRESH_TOKEN_NAME ?? 'tra_refresh_token'
      ] as string | undefined) ?? '';

    const result = await this.authService.refresh(payload, {
      refreshToken,
    } as RefreshTokenDto);

    setAuthCookies(response, {
      accessToken: result.accessToken,
      refreshToken: result.refreshToken,
    });

    return {
      sessionId: result.sessionId,
      user: result.user,
    };
  }

  @Post('logout')
  @UseGuards(JwtAuthGuard)
  async logout(
    @CurrentUser() payload: JwtPayload,
    @Body() dto: LogoutDto,
    @Res({ passthrough: true }) response: Response,
  ) {
    const result = await this.authService.logout(payload, dto);
    clearAuthCookies(response);
    return result;
  }

  @Get('me')
  @UseGuards(JwtAuthGuard)
  me(@CurrentUser() payload: JwtPayload) {
    return this.authService.me(payload);
  }
}
