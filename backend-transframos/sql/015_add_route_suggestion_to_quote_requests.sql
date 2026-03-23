-- Añade columnas para registrar la ruta sugerida por IA en solicitudes de presupuesto.

SET @column_exists := (
  SELECT COUNT(*)
  FROM information_schema.COLUMNS
  WHERE TABLE_SCHEMA = DATABASE()
    AND TABLE_NAME = 'tra_ai_quote_requests'
    AND COLUMN_NAME = 'suggested_route_id'
);

SET @ddl := IF(
  @column_exists = 0,
  'ALTER TABLE tra_ai_quote_requests ADD COLUMN suggested_route_id char(36) DEFAULT NULL COMMENT ''Ruta sugerida (catalogo)''',
  'SELECT 1'
);

PREPARE stmt FROM @ddl;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET @column_exists := (
  SELECT COUNT(*)
  FROM information_schema.COLUMNS
  WHERE TABLE_SCHEMA = DATABASE()
    AND TABLE_NAME = 'tra_ai_quote_requests'
    AND COLUMN_NAME = 'suggested_route_code'
);

SET @ddl := IF(
  @column_exists = 0,
  'ALTER TABLE tra_ai_quote_requests ADD COLUMN suggested_route_code varchar(50) DEFAULT NULL COMMENT ''Codigo de ruta sugerida''',
  'SELECT 1'
);

PREPARE stmt FROM @ddl;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET @column_exists := (
  SELECT COUNT(*)
  FROM information_schema.COLUMNS
  WHERE TABLE_SCHEMA = DATABASE()
    AND TABLE_NAME = 'tra_ai_quote_requests'
    AND COLUMN_NAME = 'suggested_route_confidence'
);

SET @ddl := IF(
  @column_exists = 0,
  'ALTER TABLE tra_ai_quote_requests ADD COLUMN suggested_route_confidence decimal(5,2) DEFAULT NULL COMMENT ''Confianza de la ruta sugerida (0-1)''',
  'SELECT 1'
);

PREPARE stmt FROM @ddl;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET @column_exists := (
  SELECT COUNT(*)
  FROM information_schema.COLUMNS
  WHERE TABLE_SCHEMA = DATABASE()
    AND TABLE_NAME = 'tra_ai_quote_requests'
    AND COLUMN_NAME = 'suggested_route_rationale'
);

SET @ddl := IF(
  @column_exists = 0,
  'ALTER TABLE tra_ai_quote_requests ADD COLUMN suggested_route_rationale text DEFAULT NULL COMMENT ''Motivo de la sugerencia IA''',
  'SELECT 1'
);

PREPARE stmt FROM @ddl;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET @column_exists := (
  SELECT COUNT(*)
  FROM information_schema.COLUMNS
  WHERE TABLE_SCHEMA = DATABASE()
    AND TABLE_NAME = 'tra_ai_quote_requests'
    AND COLUMN_NAME = 'suggested_route_accepted'
);

SET @ddl := IF(
  @column_exists = 0,
  'ALTER TABLE tra_ai_quote_requests ADD COLUMN suggested_route_accepted tinyint(1) DEFAULT NULL COMMENT ''Si se aplico la ruta sugerida''',
  'SELECT 1'
);

PREPARE stmt FROM @ddl;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;
