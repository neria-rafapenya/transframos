-- Añade campos de identificación y contacto para usuarios.

SET @column_exists := (
  SELECT COUNT(*)
  FROM information_schema.COLUMNS
  WHERE TABLE_SCHEMA = DATABASE()
    AND TABLE_NAME = 'tra_users'
    AND COLUMN_NAME = 'dni'
);

SET @ddl := IF(
  @column_exists = 0,
  "ALTER TABLE tra_users ADD COLUMN dni varchar(20) NULL AFTER full_name",
  'SELECT 1'
);

PREPARE stmt FROM @ddl;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET @column_exists := (
  SELECT COUNT(*)
  FROM information_schema.COLUMNS
  WHERE TABLE_SCHEMA = DATABASE()
    AND TABLE_NAME = 'tra_users'
    AND COLUMN_NAME = 'nif'
);

SET @ddl := IF(
  @column_exists = 0,
  "ALTER TABLE tra_users ADD COLUMN nif varchar(20) NULL AFTER dni",
  'SELECT 1'
);

PREPARE stmt FROM @ddl;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET @column_exists := (
  SELECT COUNT(*)
  FROM information_schema.COLUMNS
  WHERE TABLE_SCHEMA = DATABASE()
    AND TABLE_NAME = 'tra_users'
    AND COLUMN_NAME = 'company_name'
);

SET @ddl := IF(
  @column_exists = 0,
  "ALTER TABLE tra_users ADD COLUMN company_name varchar(255) NULL AFTER nif",
  'SELECT 1'
);

PREPARE stmt FROM @ddl;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET @column_exists := (
  SELECT COUNT(*)
  FROM information_schema.COLUMNS
  WHERE TABLE_SCHEMA = DATABASE()
    AND TABLE_NAME = 'tra_users'
    AND COLUMN_NAME = 'company_hq_address'
);

SET @ddl := IF(
  @column_exists = 0,
  "ALTER TABLE tra_users ADD COLUMN company_hq_address varchar(255) NULL AFTER company_name",
  'SELECT 1'
);

PREPARE stmt FROM @ddl;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET @column_exists := (
  SELECT COUNT(*)
  FROM information_schema.COLUMNS
  WHERE TABLE_SCHEMA = DATABASE()
    AND TABLE_NAME = 'tra_users'
    AND COLUMN_NAME = 'contact_name'
);

SET @ddl := IF(
  @column_exists = 0,
  "ALTER TABLE tra_users ADD COLUMN contact_name varchar(255) NULL AFTER company_hq_address",
  'SELECT 1'
);

PREPARE stmt FROM @ddl;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET @column_exists := (
  SELECT COUNT(*)
  FROM information_schema.COLUMNS
  WHERE TABLE_SCHEMA = DATABASE()
    AND TABLE_NAME = 'tra_users'
    AND COLUMN_NAME = 'contact_phone'
);

SET @ddl := IF(
  @column_exists = 0,
  "ALTER TABLE tra_users ADD COLUMN contact_phone varchar(40) NULL AFTER contact_name",
  'SELECT 1'
);

PREPARE stmt FROM @ddl;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET @column_exists := (
  SELECT COUNT(*)
  FROM information_schema.COLUMNS
  WHERE TABLE_SCHEMA = DATABASE()
    AND TABLE_NAME = 'tra_users'
    AND COLUMN_NAME = 'contact_phone_alt'
);

SET @ddl := IF(
  @column_exists = 0,
  "ALTER TABLE tra_users ADD COLUMN contact_phone_alt varchar(40) NULL AFTER contact_phone",
  'SELECT 1'
);

PREPARE stmt FROM @ddl;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET @column_exists := (
  SELECT COUNT(*)
  FROM information_schema.COLUMNS
  WHERE TABLE_SCHEMA = DATABASE()
    AND TABLE_NAME = 'tra_users'
    AND COLUMN_NAME = 'contact_email'
);

SET @ddl := IF(
  @column_exists = 0,
  "ALTER TABLE tra_users ADD COLUMN contact_email varchar(255) NULL AFTER contact_phone_alt",
  'SELECT 1'
);

PREPARE stmt FROM @ddl;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;
