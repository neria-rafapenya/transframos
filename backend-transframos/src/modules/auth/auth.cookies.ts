import type { Response } from 'express';

type SameSiteValue = 'lax' | 'strict' | 'none';

export function getCookieConfig() {
  const accessTokenName =
    process.env.COOKIE_ACCESS_TOKEN_NAME ?? 'tra_access_token';
  const refreshTokenName =
    process.env.COOKIE_REFRESH_TOKEN_NAME ?? 'tra_refresh_token';
  const sessionHintName =
    process.env.COOKIE_SESSION_HINT_NAME ?? 'tra_session_hint';

  const secure = String(process.env.COOKIE_SECURE ?? 'false') === 'true';

  const sameSite = (process.env.COOKIE_SAME_SITE ?? 'lax') as SameSiteValue;

  return {
    accessTokenName,
    refreshTokenName,
    sessionHintName,
    secure,
    sameSite,
  };
}

export function setAuthCookies(
  response: Response,
  payload: {
    accessToken: string;
    refreshToken: string;
  },
): void {
  const { accessTokenName, refreshTokenName, sessionHintName, secure, sameSite } =
    getCookieConfig();

  response.cookie(accessTokenName, payload.accessToken, {
    httpOnly: true,
    secure,
    sameSite,
    path: '/',
    maxAge: 15 * 60 * 1000,
  });

  response.cookie(refreshTokenName, payload.refreshToken, {
    httpOnly: true,
    secure,
    sameSite,
    path: '/',
    maxAge: 7 * 24 * 60 * 60 * 1000,
  });

  response.cookie(sessionHintName, '1', {
    httpOnly: false,
    secure,
    sameSite,
    path: '/',
    maxAge: 7 * 24 * 60 * 60 * 1000,
  });
}

export function clearAuthCookies(response: Response): void {
  const { accessTokenName, refreshTokenName, sessionHintName, secure, sameSite } =
    getCookieConfig();

  response.clearCookie(accessTokenName, {
    httpOnly: true,
    secure,
    sameSite,
    path: '/',
  });

  response.clearCookie(refreshTokenName, {
    httpOnly: true,
    secure,
    sameSite,
    path: '/',
  });

  response.clearCookie(sessionHintName, {
    httpOnly: false,
    secure,
    sameSite,
    path: '/',
  });
}
