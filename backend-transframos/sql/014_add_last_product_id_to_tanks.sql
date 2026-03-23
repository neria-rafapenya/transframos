-- Añade columna para registrar el último producto transportado por el tanque.
SET @column_exists := (
  SELECT COUNT(*)
  FROM information_schema.COLUMNS
  WHERE TABLE_SCHEMA = DATABASE()
    AND TABLE_NAME = 'tra_tanks'
    AND COLUMN_NAME = 'last_product_id'
);

SET @ddl := IF(
  @column_exists = 0,
  'ALTER TABLE tra_tanks ADD COLUMN last_product_id char(36) DEFAULT NULL COMMENT ''Ultimo producto transportado''',
  'SELECT 1'
);

PREPARE stmt FROM @ddl;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;
