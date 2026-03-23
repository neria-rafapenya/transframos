-- Seed inicial de reglas de compatibilidad producto-previo -> producto-siguiente.
START TRANSACTION;

SET @cat_food_liq := (SELECT category_id FROM tra_product_categories WHERE category_code = 'FOOD_LIQ' LIMIT 1);
SET @cat_food := (SELECT category_id FROM tra_product_categories WHERE category_code = 'FOOD' LIMIT 1);
SET @cat_feed := (SELECT category_id FROM tra_product_categories WHERE category_code = 'FEED' LIMIT 1);
SET @cat_ind := (SELECT category_id FROM tra_product_categories WHERE category_code = 'IND_LIQ' LIMIT 1);
SET @cat_adr := (SELECT category_id FROM tra_product_categories WHERE category_code = 'ADR_LIQ' LIMIT 1);
SET @cat_c3 := (SELECT category_id FROM tra_product_categories WHERE category_code = 'C3' LIMIT 1);

SET @prod_uco := (SELECT product_id FROM tra_products WHERE product_code = 'UCO' LIMIT 1);
SET @prod_grasas := (SELECT product_id FROM tra_products WHERE product_code = 'GRASAS_ANIM' LIMIT 1);
SET @prod_lodo := (SELECT product_id FROM tra_products WHERE product_code = 'LODO_VEG' LIMIT 1);

-- FOOD_LIQ -> FOOD_LIQ
INSERT INTO tra_product_compatibility_rules (
  compatibility_rule_id, previous_product_id, next_product_id,
  previous_category_id, next_category_id,
  cleaning_required, required_cleaning_type,
  cooling_or_heating_reset_required, bacteriological_filter_required,
  compatibility_status, rationale, active, valid_from, valid_to
)
SELECT UUID(), NULL, NULL,
       @cat_food_liq, @cat_food_liq,
       1, 'CIP',
       0, 1,
       'requires_cleaning',
       'Transicion entre alimentarios liquidos. Se permite con limpieza CIP previa y filtro bacteriologico para minimizar contaminacion cruzada entre productos alimentarios.',
       1, NULL, NULL
WHERE NOT EXISTS (
  SELECT 1 FROM tra_product_compatibility_rules
  WHERE previous_product_id <=> NULL
    AND next_product_id <=> NULL
    AND previous_category_id <=> @cat_food_liq
    AND next_category_id <=> @cat_food_liq
    AND compatibility_status = 'requires_cleaning'
);

-- FOOD -> FOOD
INSERT INTO tra_product_compatibility_rules (
  compatibility_rule_id, previous_product_id, next_product_id,
  previous_category_id, next_category_id,
  cleaning_required, required_cleaning_type,
  cooling_or_heating_reset_required, bacteriological_filter_required,
  compatibility_status, rationale, active, valid_from, valid_to
)
SELECT UUID(), NULL, NULL,
       @cat_food, @cat_food,
       1, 'CIP',
       0, 1,
       'requires_cleaning',
       'Transicion entre alimentarios no ADR. Se admite con CIP y filtro bacteriologico para asegurar higiene alimentaria.',
       1, NULL, NULL
WHERE NOT EXISTS (
  SELECT 1 FROM tra_product_compatibility_rules
  WHERE previous_product_id <=> NULL
    AND next_product_id <=> NULL
    AND previous_category_id <=> @cat_food
    AND next_category_id <=> @cat_food
    AND compatibility_status = 'requires_cleaning'
);

-- FOOD_LIQ -> FOOD
INSERT INTO tra_product_compatibility_rules (
  compatibility_rule_id, previous_product_id, next_product_id,
  previous_category_id, next_category_id,
  cleaning_required, required_cleaning_type,
  cooling_or_heating_reset_required, bacteriological_filter_required,
  compatibility_status, rationale, active, valid_from, valid_to
)
SELECT UUID(), NULL, NULL,
       @cat_food_liq, @cat_food,
       1, 'CIP',
       0, 1,
       'requires_cleaning',
       'De alimentario liquido a alimentario general. Se permite con CIP y filtro bacteriologico por riesgo de arrastre de residuos.',
       1, NULL, NULL
WHERE NOT EXISTS (
  SELECT 1 FROM tra_product_compatibility_rules
  WHERE previous_product_id <=> NULL
    AND next_product_id <=> NULL
    AND previous_category_id <=> @cat_food_liq
    AND next_category_id <=> @cat_food
    AND compatibility_status = 'requires_cleaning'
);

-- FOOD -> FOOD_LIQ
INSERT INTO tra_product_compatibility_rules (
  compatibility_rule_id, previous_product_id, next_product_id,
  previous_category_id, next_category_id,
  cleaning_required, required_cleaning_type,
  cooling_or_heating_reset_required, bacteriological_filter_required,
  compatibility_status, rationale, active, valid_from, valid_to
)
SELECT UUID(), NULL, NULL,
       @cat_food, @cat_food_liq,
       1, 'CIP',
       0, 1,
       'requires_cleaning',
       'De alimentario general a alimentario liquido. CIP y filtro bacteriologico obligatorios antes de cargar liquidos alimentarios.',
       1, NULL, NULL
WHERE NOT EXISTS (
  SELECT 1 FROM tra_product_compatibility_rules
  WHERE previous_product_id <=> NULL
    AND next_product_id <=> NULL
    AND previous_category_id <=> @cat_food
    AND next_category_id <=> @cat_food_liq
    AND compatibility_status = 'requires_cleaning'
);

-- FOOD_LIQ -> FEED
INSERT INTO tra_product_compatibility_rules (
  compatibility_rule_id, previous_product_id, next_product_id,
  previous_category_id, next_category_id,
  cleaning_required, required_cleaning_type,
  cooling_or_heating_reset_required, bacteriological_filter_required,
  compatibility_status, rationale, active, valid_from, valid_to
)
SELECT UUID(), NULL, NULL,
       @cat_food_liq, @cat_feed,
       1, 'STANDARD',
       0, 0,
       'requires_cleaning',
       'De alimentario a feed permitido con limpieza estandar para eliminar residuos alimentarios y evitar fermentaciones.',
       1, NULL, NULL
WHERE NOT EXISTS (
  SELECT 1 FROM tra_product_compatibility_rules
  WHERE previous_product_id <=> NULL
    AND next_product_id <=> NULL
    AND previous_category_id <=> @cat_food_liq
    AND next_category_id <=> @cat_feed
    AND compatibility_status = 'requires_cleaning'
);

-- FOOD -> FEED
INSERT INTO tra_product_compatibility_rules (
  compatibility_rule_id, previous_product_id, next_product_id,
  previous_category_id, next_category_id,
  cleaning_required, required_cleaning_type,
  cooling_or_heating_reset_required, bacteriological_filter_required,
  compatibility_status, rationale, active, valid_from, valid_to
)
SELECT UUID(), NULL, NULL,
       @cat_food, @cat_feed,
       1, 'STANDARD',
       0, 0,
       'requires_cleaning',
       'De alimentario a feed se admite con limpieza estandar para minimizar mezclas y olores.',
       1, NULL, NULL
WHERE NOT EXISTS (
  SELECT 1 FROM tra_product_compatibility_rules
  WHERE previous_product_id <=> NULL
    AND next_product_id <=> NULL
    AND previous_category_id <=> @cat_food
    AND next_category_id <=> @cat_feed
    AND compatibility_status = 'requires_cleaning'
);

-- FEED -> FOOD_LIQ (incompatible)
INSERT INTO tra_product_compatibility_rules (
  compatibility_rule_id, previous_product_id, next_product_id,
  previous_category_id, next_category_id,
  cleaning_required, required_cleaning_type,
  cooling_or_heating_reset_required, bacteriological_filter_required,
  compatibility_status, rationale, active, valid_from, valid_to
)
SELECT UUID(), NULL, NULL,
       @cat_feed, @cat_food_liq,
       0, NULL,
       0, 1,
       'incompatible',
       'No se permite pasar de feed a alimentario liquido. Riesgo alto de contaminacion cruzada y cumplimiento normativo.',
       1, NULL, NULL
WHERE NOT EXISTS (
  SELECT 1 FROM tra_product_compatibility_rules
  WHERE previous_product_id <=> NULL
    AND next_product_id <=> NULL
    AND previous_category_id <=> @cat_feed
    AND next_category_id <=> @cat_food_liq
    AND compatibility_status = 'incompatible'
);

-- FEED -> FOOD (incompatible)
INSERT INTO tra_product_compatibility_rules (
  compatibility_rule_id, previous_product_id, next_product_id,
  previous_category_id, next_category_id,
  cleaning_required, required_cleaning_type,
  cooling_or_heating_reset_required, bacteriological_filter_required,
  compatibility_status, rationale, active, valid_from, valid_to
)
SELECT UUID(), NULL, NULL,
       @cat_feed, @cat_food,
       0, NULL,
       0, 1,
       'incompatible',
       'No se permite transicion feed -> alimentario. Se requiere tanque dedicado o ciclo de limpieza validado fuera de este flujo.',
       1, NULL, NULL
WHERE NOT EXISTS (
  SELECT 1 FROM tra_product_compatibility_rules
  WHERE previous_product_id <=> NULL
    AND next_product_id <=> NULL
    AND previous_category_id <=> @cat_feed
    AND next_category_id <=> @cat_food
    AND compatibility_status = 'incompatible'
);

-- C3 -> FOOD_LIQ (incompatible)
INSERT INTO tra_product_compatibility_rules (
  compatibility_rule_id, previous_product_id, next_product_id,
  previous_category_id, next_category_id,
  cleaning_required, required_cleaning_type,
  cooling_or_heating_reset_required, bacteriological_filter_required,
  compatibility_status, rationale, active, valid_from, valid_to
)
SELECT UUID(), NULL, NULL,
       @cat_c3, @cat_food_liq,
       0, NULL,
       0, 1,
       'incompatible',
       'Material tecnico C3 no puede preceder a alimentario liquido. Riesgo de contaminantes no alimentarios.',
       1, NULL, NULL
WHERE NOT EXISTS (
  SELECT 1 FROM tra_product_compatibility_rules
  WHERE previous_product_id <=> NULL
    AND next_product_id <=> NULL
    AND previous_category_id <=> @cat_c3
    AND next_category_id <=> @cat_food_liq
    AND compatibility_status = 'incompatible'
);

-- C3 -> FOOD (incompatible)
INSERT INTO tra_product_compatibility_rules (
  compatibility_rule_id, previous_product_id, next_product_id,
  previous_category_id, next_category_id,
  cleaning_required, required_cleaning_type,
  cooling_or_heating_reset_required, bacteriological_filter_required,
  compatibility_status, rationale, active, valid_from, valid_to
)
SELECT UUID(), NULL, NULL,
       @cat_c3, @cat_food,
       0, NULL,
       0, 1,
       'incompatible',
       'Transicion C3 -> alimentario no permitida por riesgo sanitario y trazabilidad.',
       1, NULL, NULL
WHERE NOT EXISTS (
  SELECT 1 FROM tra_product_compatibility_rules
  WHERE previous_product_id <=> NULL
    AND next_product_id <=> NULL
    AND previous_category_id <=> @cat_c3
    AND next_category_id <=> @cat_food
    AND compatibility_status = 'incompatible'
);

-- ADR -> FOOD_LIQ (incompatible)
INSERT INTO tra_product_compatibility_rules (
  compatibility_rule_id, previous_product_id, next_product_id,
  previous_category_id, next_category_id,
  cleaning_required, required_cleaning_type,
  cooling_or_heating_reset_required, bacteriological_filter_required,
  compatibility_status, rationale, active, valid_from, valid_to
)
SELECT UUID(), NULL, NULL,
       @cat_adr, @cat_food_liq,
       0, NULL,
       0, 1,
       'incompatible',
       'No se permite ADR -> alimentario liquido. Riesgo quimico y normativa ADR incompatible con alimentarios.',
       1, NULL, NULL
WHERE NOT EXISTS (
  SELECT 1 FROM tra_product_compatibility_rules
  WHERE previous_product_id <=> NULL
    AND next_product_id <=> NULL
    AND previous_category_id <=> @cat_adr
    AND next_category_id <=> @cat_food_liq
    AND compatibility_status = 'incompatible'
);

-- ADR -> FOOD (incompatible)
INSERT INTO tra_product_compatibility_rules (
  compatibility_rule_id, previous_product_id, next_product_id,
  previous_category_id, next_category_id,
  cleaning_required, required_cleaning_type,
  cooling_or_heating_reset_required, bacteriological_filter_required,
  compatibility_status, rationale, active, valid_from, valid_to
)
SELECT UUID(), NULL, NULL,
       @cat_adr, @cat_food,
       0, NULL,
       0, 1,
       'incompatible',
       'No se permite ADR -> alimentario. Incompatibilidad normativa y sanitaria.',
       1, NULL, NULL
WHERE NOT EXISTS (
  SELECT 1 FROM tra_product_compatibility_rules
  WHERE previous_product_id <=> NULL
    AND next_product_id <=> NULL
    AND previous_category_id <=> @cat_adr
    AND next_category_id <=> @cat_food
    AND compatibility_status = 'incompatible'
);

-- ADR -> IND_LIQ
INSERT INTO tra_product_compatibility_rules (
  compatibility_rule_id, previous_product_id, next_product_id,
  previous_category_id, next_category_id,
  cleaning_required, required_cleaning_type,
  cooling_or_heating_reset_required, bacteriological_filter_required,
  compatibility_status, rationale, active, valid_from, valid_to
)
SELECT UUID(), NULL, NULL,
       @cat_adr, @cat_ind,
       1, 'ADR',
       1, 0,
       'requires_cleaning',
       'Transicion ADR -> industrial requiere limpieza ADR y reset termico para eliminar residuos peligrosos.',
       1, NULL, NULL
WHERE NOT EXISTS (
  SELECT 1 FROM tra_product_compatibility_rules
  WHERE previous_product_id <=> NULL
    AND next_product_id <=> NULL
    AND previous_category_id <=> @cat_adr
    AND next_category_id <=> @cat_ind
    AND compatibility_status = 'requires_cleaning'
);

-- ADR -> C3
INSERT INTO tra_product_compatibility_rules (
  compatibility_rule_id, previous_product_id, next_product_id,
  previous_category_id, next_category_id,
  cleaning_required, required_cleaning_type,
  cooling_or_heating_reset_required, bacteriological_filter_required,
  compatibility_status, rationale, active, valid_from, valid_to
)
SELECT UUID(), NULL, NULL,
       @cat_adr, @cat_c3,
       1, 'ADR',
       1, 0,
       'requires_cleaning',
       'Transicion ADR -> tecnico C3 requiere limpieza ADR y reset termico por seguridad operacional.',
       1, NULL, NULL
WHERE NOT EXISTS (
  SELECT 1 FROM tra_product_compatibility_rules
  WHERE previous_product_id <=> NULL
    AND next_product_id <=> NULL
    AND previous_category_id <=> @cat_adr
    AND next_category_id <=> @cat_c3
    AND compatibility_status = 'requires_cleaning'
);

-- IND_LIQ -> FOOD_LIQ (review)
INSERT INTO tra_product_compatibility_rules (
  compatibility_rule_id, previous_product_id, next_product_id,
  previous_category_id, next_category_id,
  cleaning_required, required_cleaning_type,
  cooling_or_heating_reset_required, bacteriological_filter_required,
  compatibility_status, rationale, active, valid_from, valid_to
)
SELECT UUID(), NULL, NULL,
       @cat_ind, @cat_food_liq,
       1, 'CIP',
       0, 1,
       'review',
       'Industrial -> alimentario liquido requiere revision manual y CIP estricto. Solo se permite si se valida ausencia de contaminantes.',
       1, NULL, NULL
WHERE NOT EXISTS (
  SELECT 1 FROM tra_product_compatibility_rules
  WHERE previous_product_id <=> NULL
    AND next_product_id <=> NULL
    AND previous_category_id <=> @cat_ind
    AND next_category_id <=> @cat_food_liq
    AND compatibility_status = 'review'
);

-- IND_LIQ -> FOOD (review)
INSERT INTO tra_product_compatibility_rules (
  compatibility_rule_id, previous_product_id, next_product_id,
  previous_category_id, next_category_id,
  cleaning_required, required_cleaning_type,
  cooling_or_heating_reset_required, bacteriological_filter_required,
  compatibility_status, rationale, active, valid_from, valid_to
)
SELECT UUID(), NULL, NULL,
       @cat_ind, @cat_food,
       1, 'CIP',
       0, 1,
       'review',
       'Industrial -> alimentario requiere revision manual y limpieza CIP previa por riesgo de trazas quimicas.',
       1, NULL, NULL
WHERE NOT EXISTS (
  SELECT 1 FROM tra_product_compatibility_rules
  WHERE previous_product_id <=> NULL
    AND next_product_id <=> NULL
    AND previous_category_id <=> @cat_ind
    AND next_category_id <=> @cat_food
    AND compatibility_status = 'review'
);

-- IND_LIQ -> C3
INSERT INTO tra_product_compatibility_rules (
  compatibility_rule_id, previous_product_id, next_product_id,
  previous_category_id, next_category_id,
  cleaning_required, required_cleaning_type,
  cooling_or_heating_reset_required, bacteriological_filter_required,
  compatibility_status, rationale, active, valid_from, valid_to
)
SELECT UUID(), NULL, NULL,
       @cat_ind, @cat_c3,
       1, 'STANDARD',
       0, 0,
       'requires_cleaning',
       'Industrial -> tecnico requiere limpieza estandar para evitar mezcla de productos y olores.',
       1, NULL, NULL
WHERE NOT EXISTS (
  SELECT 1 FROM tra_product_compatibility_rules
  WHERE previous_product_id <=> NULL
    AND next_product_id <=> NULL
    AND previous_category_id <=> @cat_ind
    AND next_category_id <=> @cat_c3
    AND compatibility_status = 'requires_cleaning'
);

-- C3 -> IND_LIQ
INSERT INTO tra_product_compatibility_rules (
  compatibility_rule_id, previous_product_id, next_product_id,
  previous_category_id, next_category_id,
  cleaning_required, required_cleaning_type,
  cooling_or_heating_reset_required, bacteriological_filter_required,
  compatibility_status, rationale, active, valid_from, valid_to
)
SELECT UUID(), NULL, NULL,
       @cat_c3, @cat_ind,
       1, 'STANDARD',
       0, 0,
       'requires_cleaning',
       'Tecnico C3 -> industrial permitido con limpieza estandar y purga de residuos.',
       1, NULL, NULL
WHERE NOT EXISTS (
  SELECT 1 FROM tra_product_compatibility_rules
  WHERE previous_product_id <=> NULL
    AND next_product_id <=> NULL
    AND previous_category_id <=> @cat_c3
    AND next_category_id <=> @cat_ind
    AND compatibility_status = 'requires_cleaning'
);

-- FEED -> IND_LIQ
INSERT INTO tra_product_compatibility_rules (
  compatibility_rule_id, previous_product_id, next_product_id,
  previous_category_id, next_category_id,
  cleaning_required, required_cleaning_type,
  cooling_or_heating_reset_required, bacteriological_filter_required,
  compatibility_status, rationale, active, valid_from, valid_to
)
SELECT UUID(), NULL, NULL,
       @cat_feed, @cat_ind,
       1, 'STANDARD',
       0, 0,
       'requires_cleaning',
       'Feed -> industrial permitido con limpieza estandar para evitar residuos organicos.',
       1, NULL, NULL
WHERE NOT EXISTS (
  SELECT 1 FROM tra_product_compatibility_rules
  WHERE previous_product_id <=> NULL
    AND next_product_id <=> NULL
    AND previous_category_id <=> @cat_feed
    AND next_category_id <=> @cat_ind
    AND compatibility_status = 'requires_cleaning'
);

-- IND_LIQ -> FEED
INSERT INTO tra_product_compatibility_rules (
  compatibility_rule_id, previous_product_id, next_product_id,
  previous_category_id, next_category_id,
  cleaning_required, required_cleaning_type,
  cooling_or_heating_reset_required, bacteriological_filter_required,
  compatibility_status, rationale, active, valid_from, valid_to
)
SELECT UUID(), NULL, NULL,
       @cat_ind, @cat_feed,
       1, 'STANDARD',
       0, 0,
       'requires_cleaning',
       'Industrial -> feed permitido con limpieza estandar previa y verificacion de ausencia de contaminantes.',
       1, NULL, NULL
WHERE NOT EXISTS (
  SELECT 1 FROM tra_product_compatibility_rules
  WHERE previous_product_id <=> NULL
    AND next_product_id <=> NULL
    AND previous_category_id <=> @cat_ind
    AND next_category_id <=> @cat_feed
    AND compatibility_status = 'requires_cleaning'
);

-- FOOD_LIQ -> IND_LIQ
INSERT INTO tra_product_compatibility_rules (
  compatibility_rule_id, previous_product_id, next_product_id,
  previous_category_id, next_category_id,
  cleaning_required, required_cleaning_type,
  cooling_or_heating_reset_required, bacteriological_filter_required,
  compatibility_status, rationale, active, valid_from, valid_to
)
SELECT UUID(), NULL, NULL,
       @cat_food_liq, @cat_ind,
       1, 'STANDARD',
       0, 0,
       'requires_cleaning',
       'Alimentario -> industrial permitido con limpieza estandar para evitar fermentaciones y olores.',
       1, NULL, NULL
WHERE NOT EXISTS (
  SELECT 1 FROM tra_product_compatibility_rules
  WHERE previous_product_id <=> NULL
    AND next_product_id <=> NULL
    AND previous_category_id <=> @cat_food_liq
    AND next_category_id <=> @cat_ind
    AND compatibility_status = 'requires_cleaning'
);

-- FOOD -> IND_LIQ
INSERT INTO tra_product_compatibility_rules (
  compatibility_rule_id, previous_product_id, next_product_id,
  previous_category_id, next_category_id,
  cleaning_required, required_cleaning_type,
  cooling_or_heating_reset_required, bacteriological_filter_required,
  compatibility_status, rationale, active, valid_from, valid_to
)
SELECT UUID(), NULL, NULL,
       @cat_food, @cat_ind,
       1, 'STANDARD',
       0, 0,
       'requires_cleaning',
       'Alimentario -> industrial permitido con limpieza estandar previa.',
       1, NULL, NULL
WHERE NOT EXISTS (
  SELECT 1 FROM tra_product_compatibility_rules
  WHERE previous_product_id <=> NULL
    AND next_product_id <=> NULL
    AND previous_category_id <=> @cat_food
    AND next_category_id <=> @cat_ind
    AND compatibility_status = 'requires_cleaning'
);

-- FEED -> C3
INSERT INTO tra_product_compatibility_rules (
  compatibility_rule_id, previous_product_id, next_product_id,
  previous_category_id, next_category_id,
  cleaning_required, required_cleaning_type,
  cooling_or_heating_reset_required, bacteriological_filter_required,
  compatibility_status, rationale, active, valid_from, valid_to
)
SELECT UUID(), NULL, NULL,
       @cat_feed, @cat_c3,
       1, 'STANDARD',
       0, 0,
       'requires_cleaning',
       'Feed -> tecnico permitido con limpieza estandar y purga de restos organicos.',
       1, NULL, NULL
WHERE NOT EXISTS (
  SELECT 1 FROM tra_product_compatibility_rules
  WHERE previous_product_id <=> NULL
    AND next_product_id <=> NULL
    AND previous_category_id <=> @cat_feed
    AND next_category_id <=> @cat_c3
    AND compatibility_status = 'requires_cleaning'
);

-- C3 -> FEED
INSERT INTO tra_product_compatibility_rules (
  compatibility_rule_id, previous_product_id, next_product_id,
  previous_category_id, next_category_id,
  cleaning_required, required_cleaning_type,
  cooling_or_heating_reset_required, bacteriological_filter_required,
  compatibility_status, rationale, active, valid_from, valid_to
)
SELECT UUID(), NULL, NULL,
       @cat_c3, @cat_feed,
       1, 'STANDARD',
       0, 0,
       'requires_cleaning',
       'Tecnico -> feed permitido solo con limpieza estandar y verificacion de residuos.',
       1, NULL, NULL
WHERE NOT EXISTS (
  SELECT 1 FROM tra_product_compatibility_rules
  WHERE previous_product_id <=> NULL
    AND next_product_id <=> NULL
    AND previous_category_id <=> @cat_c3
    AND next_category_id <=> @cat_feed
    AND compatibility_status = 'requires_cleaning'
);

-- UCO -> FOOD_LIQ (incompatible)
INSERT INTO tra_product_compatibility_rules (
  compatibility_rule_id, previous_product_id, next_product_id,
  previous_category_id, next_category_id,
  cleaning_required, required_cleaning_type,
  cooling_or_heating_reset_required, bacteriological_filter_required,
  compatibility_status, rationale, active, valid_from, valid_to
)
SELECT UUID(), @prod_uco, NULL,
       NULL, @cat_food_liq,
       0, NULL,
       0, 1,
       'incompatible',
       'UCO (aceite usado) no puede preceder a alimentario liquido por riesgo de contaminacion y olores persistentes.',
       1, NULL, NULL
WHERE NOT EXISTS (
  SELECT 1 FROM tra_product_compatibility_rules
  WHERE previous_product_id <=> @prod_uco
    AND next_product_id <=> NULL
    AND previous_category_id <=> NULL
    AND next_category_id <=> @cat_food_liq
    AND compatibility_status = 'incompatible'
);

-- UCO -> FOOD (incompatible)
INSERT INTO tra_product_compatibility_rules (
  compatibility_rule_id, previous_product_id, next_product_id,
  previous_category_id, next_category_id,
  cleaning_required, required_cleaning_type,
  cooling_or_heating_reset_required, bacteriological_filter_required,
  compatibility_status, rationale, active, valid_from, valid_to
)
SELECT UUID(), @prod_uco, NULL,
       NULL, @cat_food,
       0, NULL,
       0, 1,
       'incompatible',
       'UCO no puede preceder a alimentario por riesgo de contaminantes y trazas no aptas para consumo.',
       1, NULL, NULL
WHERE NOT EXISTS (
  SELECT 1 FROM tra_product_compatibility_rules
  WHERE previous_product_id <=> @prod_uco
    AND next_product_id <=> NULL
    AND previous_category_id <=> NULL
    AND next_category_id <=> @cat_food
    AND compatibility_status = 'incompatible'
);

-- Grasas animales -> FOOD_LIQ (incompatible)
INSERT INTO tra_product_compatibility_rules (
  compatibility_rule_id, previous_product_id, next_product_id,
  previous_category_id, next_category_id,
  cleaning_required, required_cleaning_type,
  cooling_or_heating_reset_required, bacteriological_filter_required,
  compatibility_status, rationale, active, valid_from, valid_to
)
SELECT UUID(), @prod_grasas, NULL,
       NULL, @cat_food_liq,
       0, NULL,
       0, 1,
       'incompatible',
       'Grasas animales no pueden preceder a alimentario liquido por riesgo sanitario y contaminacion cruzada.',
       1, NULL, NULL
WHERE NOT EXISTS (
  SELECT 1 FROM tra_product_compatibility_rules
  WHERE previous_product_id <=> @prod_grasas
    AND next_product_id <=> NULL
    AND previous_category_id <=> NULL
    AND next_category_id <=> @cat_food_liq
    AND compatibility_status = 'incompatible'
);

-- Grasas animales -> FOOD (incompatible)
INSERT INTO tra_product_compatibility_rules (
  compatibility_rule_id, previous_product_id, next_product_id,
  previous_category_id, next_category_id,
  cleaning_required, required_cleaning_type,
  cooling_or_heating_reset_required, bacteriological_filter_required,
  compatibility_status, rationale, active, valid_from, valid_to
)
SELECT UUID(), @prod_grasas, NULL,
       NULL, @cat_food,
       0, NULL,
       0, 1,
       'incompatible',
       'Grasas animales no pueden preceder a alimentario. Se requiere circuito dedicado.',
       1, NULL, NULL
WHERE NOT EXISTS (
  SELECT 1 FROM tra_product_compatibility_rules
  WHERE previous_product_id <=> @prod_grasas
    AND next_product_id <=> NULL
    AND previous_category_id <=> NULL
    AND next_category_id <=> @cat_food
    AND compatibility_status = 'incompatible'
);

-- Lodo vegetal -> FOOD_LIQ (incompatible)
INSERT INTO tra_product_compatibility_rules (
  compatibility_rule_id, previous_product_id, next_product_id,
  previous_category_id, next_category_id,
  cleaning_required, required_cleaning_type,
  cooling_or_heating_reset_required, bacteriological_filter_required,
  compatibility_status, rationale, active, valid_from, valid_to
)
SELECT UUID(), @prod_lodo, NULL,
       NULL, @cat_food_liq,
       0, NULL,
       0, 1,
       'incompatible',
       'Lodo vegetal es tecnico y no puede preceder a alimentarios liquidos por riesgo de contaminacion y residuos solidos.',
       1, NULL, NULL
WHERE NOT EXISTS (
  SELECT 1 FROM tra_product_compatibility_rules
  WHERE previous_product_id <=> @prod_lodo
    AND next_product_id <=> NULL
    AND previous_category_id <=> NULL
    AND next_category_id <=> @cat_food_liq
    AND compatibility_status = 'incompatible'
);

-- Lodo vegetal -> FOOD (incompatible)
INSERT INTO tra_product_compatibility_rules (
  compatibility_rule_id, previous_product_id, next_product_id,
  previous_category_id, next_category_id,
  cleaning_required, required_cleaning_type,
  cooling_or_heating_reset_required, bacteriological_filter_required,
  compatibility_status, rationale, active, valid_from, valid_to
)
SELECT UUID(), @prod_lodo, NULL,
       NULL, @cat_food,
       0, NULL,
       0, 1,
       'incompatible',
       'Lodo vegetal no puede preceder a alimentario por contaminacion fisica y biologica. Solo tanques dedicados.',
       1, NULL, NULL
WHERE NOT EXISTS (
  SELECT 1 FROM tra_product_compatibility_rules
  WHERE previous_product_id <=> @prod_lodo
    AND next_product_id <=> NULL
    AND previous_category_id <=> NULL
    AND next_category_id <=> @cat_food
    AND compatibility_status = 'incompatible'
);

COMMIT;
