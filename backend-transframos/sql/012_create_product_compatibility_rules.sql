-- Reglas de compatibilidad entre producto previo y siguiente en el mismo tanque.
CREATE TABLE IF NOT EXISTS `tra_product_compatibility_rules` (
  `compatibility_rule_id` char(36) NOT NULL COMMENT 'Identificador de regla',
  `previous_product_id` char(36) DEFAULT NULL COMMENT 'Producto previo (opcional)',
  `next_product_id` char(36) DEFAULT NULL COMMENT 'Producto siguiente (opcional)',
  `previous_category_id` char(36) DEFAULT NULL COMMENT 'Categoría previa (opcional)',
  `next_category_id` char(36) DEFAULT NULL COMMENT 'Categoría siguiente (opcional)',
  `cleaning_required` tinyint(1) NOT NULL DEFAULT 0 COMMENT 'Requiere limpieza',
  `required_cleaning_type` varchar(30) DEFAULT NULL COMMENT 'Tipo de limpieza requerida',
  `cooling_or_heating_reset_required` tinyint(1) NOT NULL DEFAULT 0 COMMENT 'Requiere reset térmico',
  `bacteriological_filter_required` tinyint(1) NOT NULL DEFAULT 0 COMMENT 'Requiere filtro bacteriológico',
  `compatibility_status` varchar(20) NOT NULL COMMENT 'Estado de compatibilidad',
  `rationale` text DEFAULT NULL COMMENT 'Explicación de la regla',
  `active` tinyint(1) NOT NULL DEFAULT 1 COMMENT 'Regla activa',
  `valid_from` date DEFAULT NULL COMMENT 'Inicio de vigencia',
  `valid_to` date DEFAULT NULL COMMENT 'Fin de vigencia',
  PRIMARY KEY (`compatibility_rule_id`),
  INDEX `idx_tra_comp_rules_prev_product` (`previous_product_id`),
  INDEX `idx_tra_comp_rules_next_product` (`next_product_id`),
  INDEX `idx_tra_comp_rules_prev_category` (`previous_category_id`),
  INDEX `idx_tra_comp_rules_next_category` (`next_category_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Reglas de compatibilidad de producto (secuencia en tanque)';
