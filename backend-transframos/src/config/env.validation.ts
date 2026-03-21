type EnvRecord = Record<string, string | undefined>;

function requireString(env: EnvRecord, key: string): string {
  const value = env[key];

  if (!value || value.trim().length === 0) {
    throw new Error(`Environment variable ${key} is required`);
  }

  return value;
}

function requireNumber(env: EnvRecord, key: string): number {
  const raw = requireString(env, key);
  const parsed = Number(raw);

  if (Number.isNaN(parsed)) {
    throw new Error(`Environment variable ${key} must be a valid number`);
  }

  return parsed;
}

function optionalNumber(env: EnvRecord, key: string): number | undefined {
  const raw = env[key];

  if (!raw || raw.trim().length === 0) {
    return undefined;
  }

  const parsed = Number(raw);

  if (Number.isNaN(parsed)) {
    throw new Error(`Environment variable ${key} must be a valid number`);
  }

  return parsed;
}

function optionalBoolean(env: EnvRecord, key: string): boolean | undefined {
  const raw = env[key];

  if (!raw || raw.trim().length === 0) {
    return undefined;
  }

  const normalized = raw.trim().toLowerCase();

  if (['true', '1', 'yes', 'y'].includes(normalized)) {
    return true;
  }

  if (['false', '0', 'no', 'n'].includes(normalized)) {
    return false;
  }

  throw new Error(
    `Environment variable ${key} must be a valid boolean (true/false)`,
  );
}

export function validateEnv(env: EnvRecord): EnvRecord {
  requireString(env, 'NODE_ENV');
  requireNumber(env, 'PORT');

  requireString(env, 'DB_HOST');
  requireNumber(env, 'DB_PORT');
  requireString(env, 'DB_USERNAME');
  requireString(env, 'DB_PASSWORD');
  requireString(env, 'DB_NAME');

  requireString(env, 'JWT_ACCESS_SECRET');
  requireString(env, 'JWT_REFRESH_SECRET');
  requireString(env, 'JWT_ACCESS_EXPIRES_IN');
  requireString(env, 'JWT_REFRESH_EXPIRES_IN');

  requireString(env, 'CORS_ALLOWED_ORIGINS');

  requireString(env, 'LLM_PROVIDER');
  requireString(env, 'OPENAI_API_KEY');
  requireString(env, 'OPENAI_BASE_URL');

  optionalNumber(env, 'PRICING_FALLBACK_SPEED_KMH');
  optionalBoolean(env, 'DB_SYNCHRONIZE');

  requireString(env, 'COOKIE_ACCESS_TOKEN_NAME');
  requireString(env, 'COOKIE_REFRESH_TOKEN_NAME');
  requireString(env, 'COOKIE_SECURE');
  requireString(env, 'COOKIE_SAME_SITE');

  return env;
}
