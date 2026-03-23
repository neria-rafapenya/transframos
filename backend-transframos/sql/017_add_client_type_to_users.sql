-- Añade el tipo de cliente para distinguir fidelizados de nuevos.

SET @column_exists := (
  SELECT COUNT(*)
  FROM information_schema.COLUMNS
  WHERE TABLE_SCHEMA = DATABASE()
    AND TABLE_NAME = 'tra_users'
    AND COLUMN_NAME = 'client_type'
);

SET @ddl := IF(
  @column_exists = 0,
  "ALTER TABLE tra_users ADD COLUMN client_type enum('fidelizado','nuevo') NOT NULL DEFAULT 'fidelizado' COMMENT 'Tipo de cliente'",
  'SELECT 1'
);

PREPARE stmt FROM @ddl;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;
