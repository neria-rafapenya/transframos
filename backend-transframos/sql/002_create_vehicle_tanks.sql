-- Relación vehículo-tanque para garantizar compatibilidad de producto.
CREATE TABLE IF NOT EXISTS `tra_vehicle_tanks` (
  `vehicle_tank_id` char(36) NOT NULL COMMENT 'Identificador de relación vehículo-tanque',
  `vehicle_id` char(36) NOT NULL COMMENT 'Vehículo',
  `tank_id` char(36) NOT NULL COMMENT 'Tanque',
  `active` tinyint(1) NOT NULL DEFAULT 1 COMMENT 'Relación activa',
  `valid_from` date DEFAULT NULL COMMENT 'Inicio de vigencia',
  `valid_to` date DEFAULT NULL COMMENT 'Fin de vigencia',
  `notes` text DEFAULT NULL COMMENT 'Observaciones',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp() COMMENT 'Creación',
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp() COMMENT 'Última actualización',
  PRIMARY KEY (`vehicle_tank_id`),
  INDEX `idx_tra_vehicle_tanks_vehicle` (`vehicle_id`),
  INDEX `idx_tra_vehicle_tanks_tank` (`tank_id`),
  CONSTRAINT `fk_tra_vehicle_tanks_vehicle`
    FOREIGN KEY (`vehicle_id`) REFERENCES `tra_vehicles`(`vehicle_id`),
  CONSTRAINT `fk_tra_vehicle_tanks_tank`
    FOREIGN KEY (`tank_id`) REFERENCES `tra_tanks`(`tank_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Relación vehículo-tanque';
