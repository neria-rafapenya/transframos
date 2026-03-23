-- Tabla de paradas/waypoints para rutas complejas.
CREATE TABLE IF NOT EXISTS `tra_route_waypoints` (
  `route_waypoint_id` char(36) NOT NULL COMMENT 'Identificador de la parada',
  `route_id` char(36) NOT NULL COMMENT 'Ruta',
  `sequence_no` int NOT NULL COMMENT 'Orden de la parada',
  `waypoint_name` varchar(150) NOT NULL COMMENT 'Nombre de la parada',
  `city` varchar(100) DEFAULT NULL COMMENT 'Ciudad',
  `latitude` decimal(9,6) DEFAULT NULL COMMENT 'Latitud',
  `longitude` decimal(9,6) DEFAULT NULL COMMENT 'Longitud',
  `notes` text DEFAULT NULL COMMENT 'Observaciones',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp() COMMENT 'Creación',
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp() COMMENT 'Última actualización',
  PRIMARY KEY (`route_waypoint_id`),
  UNIQUE KEY `uk_tra_route_waypoints_route_seq` (`route_id`, `sequence_no`),
  INDEX `idx_tra_route_waypoints_route` (`route_id`),
  CONSTRAINT `fk_tra_route_waypoints_route`
    FOREIGN KEY (`route_id`) REFERENCES `tra_routes`(`route_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Paradas de ruta';
