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
  requireString(env, 'OPENAI_BASE_URL');

  return env;
}
