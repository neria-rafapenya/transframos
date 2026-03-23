-- Añade client_id para vincular usuarios con clientes.

SET @column_exists := (
  SELECT COUNT(*)
  FROM information_schema.COLUMNS
  WHERE TABLE_SCHEMA = DATABASE()
    AND TABLE_NAME = 'tra_users'
    AND COLUMN_NAME = 'client_id'
);

SET @ddl := IF(
  @column_exists = 0,
  "ALTER TABLE tra_users ADD COLUMN client_id char(36) NULL AFTER id",
  'SELECT 1'
);

PREPARE stmt FROM @ddl;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET @index_exists := (
  SELECT COUNT(*)
  FROM information_schema.STATISTICS
  WHERE TABLE_SCHEMA = DATABASE()
    AND TABLE_NAME = 'tra_users'
    AND INDEX_NAME = 'idx_tra_users_client_id'
);

SET @ddl := IF(
  @index_exists = 0,
  "ALTER TABLE tra_users ADD KEY idx_tra_users_client_id (client_id)",
  'SELECT 1'
);

PREPARE stmt FROM @ddl;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;
