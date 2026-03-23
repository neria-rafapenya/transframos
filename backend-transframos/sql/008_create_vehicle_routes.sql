-- Relación vehículo-ruta para priorizar vehículos habituales en un trayecto.
CREATE TABLE IF NOT EXISTS `tra_vehicle_routes` (
  `vehicle_route_id` char(36) NOT NULL COMMENT 'Identificador de relación vehículo-ruta',
  `vehicle_id` char(36) NOT NULL COMMENT 'Vehículo',
  `route_id` char(36) NOT NULL COMMENT 'Ruta',
  `active` tinyint(1) NOT NULL DEFAULT 1 COMMENT 'Relación activa',
  `valid_from` date DEFAULT NULL COMMENT 'Inicio de vigencia',
  `valid_to` date DEFAULT NULL COMMENT 'Fin de vigencia',
  `notes` text DEFAULT NULL COMMENT 'Observaciones',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp() COMMENT 'Creación',
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp() COMMENT 'Última actualización',
  PRIMARY KEY (`vehicle_route_id`),
  INDEX `idx_tra_vehicle_routes_vehicle` (`vehicle_id`),
  INDEX `idx_tra_vehicle_routes_route` (`route_id`),
  CONSTRAINT `fk_tra_vehicle_routes_vehicle`
    FOREIGN KEY (`vehicle_id`) REFERENCES `tra_vehicles`(`vehicle_id`),
  CONSTRAINT `fk_tra_vehicle_routes_route`
    FOREIGN KEY (`route_id`) REFERENCES `tra_routes`(`route_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Relación vehículo-ruta';
