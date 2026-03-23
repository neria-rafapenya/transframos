-- Seed de datos de ejemplo para sandbox.
-- Inserta catálogos, puntos, rutas, vehículos, tanques, asignaciones y waypoints.
-- Usa NOT EXISTS para evitar duplicados.

START TRANSACTION;

-- =========================
-- Categorías de producto
-- =========================
SET @cat_food := (SELECT category_id FROM tra_product_categories WHERE category_code = 'FOOD_LIQ' LIMIT 1);
SET @cat_food := IFNULL(@cat_food, 'b6d2d2b2-26d5-11f1-9b4a-5a0d05a37ed2');
INSERT INTO tra_product_categories (
  category_id, category_code, category_name, description,
  requires_food_grade, requires_feed_grade, requires_sandach, requires_adr,
  default_cleaning_level, allows_intermodal, active, created_at, updated_at
)
SELECT @cat_food, 'FOOD_LIQ', 'Líquidos alimentarios', 'Productos alimentarios líquidos',
       1, 0, 0, 0,
       'CIP', 0, 1, NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM tra_product_categories WHERE category_code = 'FOOD_LIQ');

SET @cat_ind := (SELECT category_id FROM tra_product_categories WHERE category_code = 'IND_LIQ' LIMIT 1);
SET @cat_ind := IFNULL(@cat_ind, 'b6d2d3c8-26d5-11f1-9b4a-5a0d05a37ed2');
INSERT INTO tra_product_categories (
  category_id, category_code, category_name, description,
  requires_food_grade, requires_feed_grade, requires_sandach, requires_adr,
  default_cleaning_level, allows_intermodal, active, created_at, updated_at
)
SELECT @cat_ind, 'IND_LIQ', 'Líquidos industriales', 'Productos industriales líquidos',
       0, 0, 0, 0,
       'STANDARD', 1, 1, NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM tra_product_categories WHERE category_code = 'IND_LIQ');

SET @cat_adr := (SELECT category_id FROM tra_product_categories WHERE category_code = 'ADR_LIQ' LIMIT 1);
SET @cat_adr := IFNULL(@cat_adr, 'b6d2d4d6-26d5-11f1-9b4a-5a0d05a37ed2');
INSERT INTO tra_product_categories (
  category_id, category_code, category_name, description,
  requires_food_grade, requires_feed_grade, requires_sandach, requires_adr,
  default_cleaning_level, allows_intermodal, active, created_at, updated_at
)
SELECT @cat_adr, 'ADR_LIQ', 'Líquidos ADR', 'Productos ADR líquidos',
       0, 0, 0, 1,
       'ADR', 0, 1, NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM tra_product_categories WHERE category_code = 'ADR_LIQ');

-- Categorías adicionales solicitadas
SET @cat_food_simple := (SELECT category_id FROM tra_product_categories WHERE category_code = 'FOOD' LIMIT 1);
SET @cat_food_simple := IFNULL(@cat_food_simple, 'b6d2d7c0-26d5-11f1-9b4a-5a0d05a37ed2');
INSERT INTO tra_product_categories (
  category_id, category_code, category_name, description,
  requires_food_grade, requires_feed_grade, requires_sandach, requires_adr,
  default_cleaning_level, allows_intermodal, active, created_at, updated_at
)
SELECT @cat_food_simple, 'FOOD', 'Alimentario', 'Productos alimentarios',
       1, 0, 0, 0,
       'CIP', 0, 1, NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM tra_product_categories WHERE category_code = 'FOOD');

SET @cat_feed := (SELECT category_id FROM tra_product_categories WHERE category_code = 'FEED' LIMIT 1);
SET @cat_feed := IFNULL(@cat_feed, 'b6d2d8ce-26d5-11f1-9b4a-5a0d05a37ed2');
INSERT INTO tra_product_categories (
  category_id, category_code, category_name, description,
  requires_food_grade, requires_feed_grade, requires_sandach, requires_adr,
  default_cleaning_level, allows_intermodal, active, created_at, updated_at
)
SELECT @cat_feed, 'FEED', 'Alimentación animal', 'Productos para alimentación animal',
       0, 1, 0, 0,
       'STANDARD', 0, 1, NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM tra_product_categories WHERE category_code = 'FEED');

SET @cat_c3 := (SELECT category_id FROM tra_product_categories WHERE category_code = 'C3' LIMIT 1);
SET @cat_c3 := IFNULL(@cat_c3, 'b6d2d9dc-26d5-11f1-9b4a-5a0d05a37ed2');
INSERT INTO tra_product_categories (
  category_id, category_code, category_name, description,
  requires_food_grade, requires_feed_grade, requires_sandach, requires_adr,
  default_cleaning_level, allows_intermodal, active, created_at, updated_at
)
SELECT @cat_c3, 'C3', 'Técnico', 'Productos técnicos (C3)',
       0, 0, 0, 0,
       'STANDARD', 1, 1, NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM tra_product_categories WHERE category_code = 'C3');

-- =========================
-- Productos
-- =========================
SET @prod_milk := (SELECT product_id FROM tra_products WHERE product_code = 'LECHE' LIMIT 1);
SET @prod_milk := IFNULL(@prod_milk, 'b6d2f0b6-26d5-11f1-9b4a-5a0d05a37ed2');
INSERT INTO tra_products (
  product_id, product_code, product_name, commercial_name, category_id,
  density_kg_l, adr_required, adr_class, food_grade_required, feed_grade_required,
  sandach_required, temperature_min_c, temperature_max_c, needs_heating, needs_cooling,
  needs_bacteriological_filter, viscosity_level, cleaning_level_required,
  discharge_type_required, default_max_transport_hours, active, notes
)
SELECT @prod_milk, 'LECHE', 'Leche', 'Leche cruda', @cat_food,
       1.03, 0, NULL, 1, 0,
       0, 2, 6, 0, 1,
       1, 'low', 'CIP', 'pump', 24, 1, 'Producto alimentario.'
WHERE NOT EXISTS (SELECT 1 FROM tra_products WHERE product_code = 'LECHE');

SET @prod_oil := (SELECT product_id FROM tra_products WHERE product_code = 'ACEITE' LIMIT 1);
SET @prod_oil := IFNULL(@prod_oil, 'b6d2f1a6-26d5-11f1-9b4a-5a0d05a37ed2');
INSERT INTO tra_products (
  product_id, product_code, product_name, commercial_name, category_id,
  density_kg_l, adr_required, adr_class, food_grade_required, feed_grade_required,
  sandach_required, temperature_min_c, temperature_max_c, needs_heating, needs_cooling,
  needs_bacteriological_filter, viscosity_level, cleaning_level_required,
  discharge_type_required, default_max_transport_hours, active, notes
)
SELECT @prod_oil, 'ACEITE', 'Aceite de oliva', 'Aceite de oliva virgen', @cat_food,
       0.92, 0, NULL, 1, 0,
       0, 10, 30, 0, 0,
       1, 'medium', 'CIP', 'pump', 48, 1, 'Requiere tanque alimentario.'
WHERE NOT EXISTS (SELECT 1 FROM tra_products WHERE product_code = 'ACEITE');

SET @prod_wine := (SELECT product_id FROM tra_products WHERE product_code = 'VINO' LIMIT 1);
SET @prod_wine := IFNULL(@prod_wine, 'b6d2f2c4-26d5-11f1-9b4a-5a0d05a37ed2');
INSERT INTO tra_products (
  product_id, product_code, product_name, commercial_name, category_id,
  density_kg_l, adr_required, adr_class, food_grade_required, feed_grade_required,
  sandach_required, temperature_min_c, temperature_max_c, needs_heating, needs_cooling,
  needs_bacteriological_filter, viscosity_level, cleaning_level_required,
  discharge_type_required, default_max_transport_hours, active, notes
)
SELECT @prod_wine, 'VINO', 'Vino', 'Vino a granel', @cat_food,
       0.99, 0, NULL, 1, 0,
       0, 8, 20, 0, 0,
       1, 'low', 'CIP', 'pump', 72, 1, 'Alimentario.'
WHERE NOT EXISTS (SELECT 1 FROM tra_products WHERE product_code = 'VINO');

SET @prod_juice := (SELECT product_id FROM tra_products WHERE product_code = 'ZUMO' LIMIT 1);
SET @prod_juice := IFNULL(@prod_juice, 'b6d2f3d2-26d5-11f1-9b4a-5a0d05a37ed2');
INSERT INTO tra_products (
  product_id, product_code, product_name, commercial_name, category_id,
  density_kg_l, adr_required, adr_class, food_grade_required, feed_grade_required,
  sandach_required, temperature_min_c, temperature_max_c, needs_heating, needs_cooling,
  needs_bacteriological_filter, viscosity_level, cleaning_level_required,
  discharge_type_required, default_max_transport_hours, active, notes
)
SELECT @prod_juice, 'ZUMO', 'Zumo', 'Zumo concentrado', @cat_food,
       1.05, 0, NULL, 1, 0,
       0, 2, 8, 0, 1,
       1, 'medium', 'CIP', 'pump', 24, 1, 'Refrigerado.'
WHERE NOT EXISTS (SELECT 1 FROM tra_products WHERE product_code = 'ZUMO');

SET @prod_gly := (SELECT product_id FROM tra_products WHERE product_code = 'GLICERINA' LIMIT 1);
SET @prod_gly := IFNULL(@prod_gly, 'b6d2f4e0-26d5-11f1-9b4a-5a0d05a37ed2');
INSERT INTO tra_products (
  product_id, product_code, product_name, commercial_name, category_id,
  density_kg_l, adr_required, adr_class, food_grade_required, feed_grade_required,
  sandach_required, temperature_min_c, temperature_max_c, needs_heating, needs_cooling,
  needs_bacteriological_filter, viscosity_level, cleaning_level_required,
  discharge_type_required, default_max_transport_hours, active, notes
)
SELECT @prod_gly, 'GLICERINA', 'Glicerina', 'Glicerina técnica', @cat_ind,
       1.26, 0, NULL, 0, 0,
       0, 10, 30, 0, 0,
       0, 'high', 'STANDARD', 'pump', 72, 1, 'Industrial.'
WHERE NOT EXISTS (SELECT 1 FROM tra_products WHERE product_code = 'GLICERINA');

SET @prod_naoh := (SELECT product_id FROM tra_products WHERE product_code = 'SOSAC' LIMIT 1);
SET @prod_naoh := IFNULL(@prod_naoh, 'b6d2f5ee-26d5-11f1-9b4a-5a0d05a37ed2');
INSERT INTO tra_products (
  product_id, product_code, product_name, commercial_name, category_id,
  density_kg_l, adr_required, adr_class, food_grade_required, feed_grade_required,
  sandach_required, temperature_min_c, temperature_max_c, needs_heating, needs_cooling,
  needs_bacteriological_filter, viscosity_level, cleaning_level_required,
  discharge_type_required, default_max_transport_hours, active, notes
)
SELECT @prod_naoh, 'SOSAC', 'Sosa cáustica', 'Hidróxido de sodio', @cat_adr,
       1.53, 1, '8', 0, 0,
       0, 10, 40, 0, 0,
       0, 'medium', 'ADR', 'pump', 48, 1, 'ADR clase 8.'
WHERE NOT EXISTS (SELECT 1 FROM tra_products WHERE product_code = 'SOSAC');

-- =========================
-- Productos extra (50)
-- =========================

-- FOOD_LIQ (10)
INSERT INTO tra_products (
  product_id, product_code, product_name, commercial_name, category_id,
  density_kg_l, adr_required, adr_class, food_grade_required, feed_grade_required,
  sandach_required, temperature_min_c, temperature_max_c, needs_heating, needs_cooling,
  needs_bacteriological_filter, viscosity_level, cleaning_level_required,
  discharge_type_required, default_max_transport_hours, active, notes
)
SELECT UUID(), 'FLQ-001', 'Nata liquida', 'Nata liquida', @cat_food,
       1.01, 0, NULL, 1, 0,
       0, 2, 8, 0, 1,
       1, 'low', 'CIP', 'pump', 24, 1, 'Sandbox.'
WHERE NOT EXISTS (SELECT 1 FROM tra_products WHERE product_code = 'FLQ-001');

INSERT INTO tra_products (
  product_id, product_code, product_name, commercial_name, category_id,
  density_kg_l, adr_required, adr_class, food_grade_required, feed_grade_required,
  sandach_required, temperature_min_c, temperature_max_c, needs_heating, needs_cooling,
  needs_bacteriological_filter, viscosity_level, cleaning_level_required,
  discharge_type_required, default_max_transport_hours, active, notes
)
SELECT UUID(), 'FLQ-002', 'Suero lacteo', 'Suero lacteo', @cat_food,
       1.02, 0, NULL, 1, 0,
       0, 2, 8, 0, 1,
       1, 'low', 'CIP', 'pump', 24, 1, 'Sandbox.'
WHERE NOT EXISTS (SELECT 1 FROM tra_products WHERE product_code = 'FLQ-002');

INSERT INTO tra_products (
  product_id, product_code, product_name, commercial_name, category_id,
  density_kg_l, adr_required, adr_class, food_grade_required, feed_grade_required,
  sandach_required, temperature_min_c, temperature_max_c, needs_heating, needs_cooling,
  needs_bacteriological_filter, viscosity_level, cleaning_level_required,
  discharge_type_required, default_max_transport_hours, active, notes
)
SELECT UUID(), 'FLQ-003', 'Yogur base', 'Yogur base', @cat_food,
       1.03, 0, NULL, 1, 0,
       0, 2, 8, 0, 1,
       1, 'medium', 'CIP', 'pump', 24, 1, 'Sandbox.'
WHERE NOT EXISTS (SELECT 1 FROM tra_products WHERE product_code = 'FLQ-003');

INSERT INTO tra_products (
  product_id, product_code, product_name, commercial_name, category_id,
  density_kg_l, adr_required, adr_class, food_grade_required, feed_grade_required,
  sandach_required, temperature_min_c, temperature_max_c, needs_heating, needs_cooling,
  needs_bacteriological_filter, viscosity_level, cleaning_level_required,
  discharge_type_required, default_max_transport_hours, active, notes
)
SELECT UUID(), 'FLQ-004', 'Mosto cerveza', 'Mosto cerveza', @cat_food,
       1.00, 0, NULL, 1, 0,
       0, 2, 10, 0, 0,
       1, 'low', 'CIP', 'pump', 36, 1, 'Sandbox.'
WHERE NOT EXISTS (SELECT 1 FROM tra_products WHERE product_code = 'FLQ-004');

INSERT INTO tra_products (
  product_id, product_code, product_name, commercial_name, category_id,
  density_kg_l, adr_required, adr_class, food_grade_required, feed_grade_required,
  sandach_required, temperature_min_c, temperature_max_c, needs_heating, needs_cooling,
  needs_bacteriological_filter, viscosity_level, cleaning_level_required,
  discharge_type_required, default_max_transport_hours, active, notes
)
SELECT UUID(), 'FLQ-005', 'Agua mineral', 'Agua mineral', @cat_food,
       1.00, 0, NULL, 1, 0,
       0, 4, 20, 0, 0,
       0, 'low', 'CIP', 'pump', 72, 1, 'Sandbox.'
WHERE NOT EXISTS (SELECT 1 FROM tra_products WHERE product_code = 'FLQ-005');

INSERT INTO tra_products (
  product_id, product_code, product_name, commercial_name, category_id,
  density_kg_l, adr_required, adr_class, food_grade_required, feed_grade_required,
  sandach_required, temperature_min_c, temperature_max_c, needs_heating, needs_cooling,
  needs_bacteriological_filter, viscosity_level, cleaning_level_required,
  discharge_type_required, default_max_transport_hours, active, notes
)
SELECT UUID(), 'FLQ-006', 'Jarabe glucosa', 'Jarabe glucosa', @cat_food,
       1.35, 0, NULL, 1, 0,
       0, 10, 30, 0, 0,
       1, 'high', 'CIP', 'pump', 48, 1, 'Sandbox.'
WHERE NOT EXISTS (SELECT 1 FROM tra_products WHERE product_code = 'FLQ-006');

INSERT INTO tra_products (
  product_id, product_code, product_name, commercial_name, category_id,
  density_kg_l, adr_required, adr_class, food_grade_required, feed_grade_required,
  sandach_required, temperature_min_c, temperature_max_c, needs_heating, needs_cooling,
  needs_bacteriological_filter, viscosity_level, cleaning_level_required,
  discharge_type_required, default_max_transport_hours, active, notes
)
SELECT UUID(), 'FLQ-007', 'Bebida vegetal', 'Bebida vegetal', @cat_food,
       1.01, 0, NULL, 1, 0,
       0, 2, 8, 0, 1,
       1, 'low', 'CIP', 'pump', 24, 1, 'Sandbox.'
WHERE NOT EXISTS (SELECT 1 FROM tra_products WHERE product_code = 'FLQ-007');

INSERT INTO tra_products (
  product_id, product_code, product_name, commercial_name, category_id,
  density_kg_l, adr_required, adr_class, food_grade_required, feed_grade_required,
  sandach_required, temperature_min_c, temperature_max_c, needs_heating, needs_cooling,
  needs_bacteriological_filter, viscosity_level, cleaning_level_required,
  discharge_type_required, default_max_transport_hours, active, notes
)
SELECT UUID(), 'FLQ-008', 'Sirope azucar', 'Sirope azucar', @cat_food,
       1.30, 0, NULL, 1, 0,
       0, 10, 30, 0, 0,
       1, 'high', 'CIP', 'pump', 48, 1, 'Sandbox.'
WHERE NOT EXISTS (SELECT 1 FROM tra_products WHERE product_code = 'FLQ-008');

INSERT INTO tra_products (
  product_id, product_code, product_name, commercial_name, category_id,
  density_kg_l, adr_required, adr_class, food_grade_required, feed_grade_required,
  sandach_required, temperature_min_c, temperature_max_c, needs_heating, needs_cooling,
  needs_bacteriological_filter, viscosity_level, cleaning_level_required,
  discharge_type_required, default_max_transport_hours, active, notes
)
SELECT UUID(), 'FLQ-009', 'Caldo vegetal', 'Caldo vegetal', @cat_food,
       1.00, 0, NULL, 1, 0,
       0, 4, 20, 0, 0,
       1, 'low', 'CIP', 'pump', 48, 1, 'Sandbox.'
WHERE NOT EXISTS (SELECT 1 FROM tra_products WHERE product_code = 'FLQ-009');

INSERT INTO tra_products (
  product_id, product_code, product_name, commercial_name, category_id,
  density_kg_l, adr_required, adr_class, food_grade_required, feed_grade_required,
  sandach_required, temperature_min_c, temperature_max_c, needs_heating, needs_cooling,
  needs_bacteriological_filter, viscosity_level, cleaning_level_required,
  discharge_type_required, default_max_transport_hours, active, notes
)
SELECT UUID(), 'FLQ-010', 'Huevo liquido', 'Huevo liquido', @cat_food,
       1.05, 0, NULL, 1, 0,
       0, 2, 6, 0, 1,
       1, 'medium', 'CIP', 'pump', 24, 1, 'Sandbox.'
WHERE NOT EXISTS (SELECT 1 FROM tra_products WHERE product_code = 'FLQ-010');

-- FOOD (10)
INSERT INTO tra_products (
  product_id, product_code, product_name, commercial_name, category_id,
  density_kg_l, adr_required, adr_class, food_grade_required, feed_grade_required,
  sandach_required, temperature_min_c, temperature_max_c, needs_heating, needs_cooling,
  needs_bacteriological_filter, viscosity_level, cleaning_level_required,
  discharge_type_required, default_max_transport_hours, active, notes
)
SELECT UUID(), 'FOOD-001', 'Aceite girasol', 'Aceite girasol', @cat_food_simple,
       0.92, 0, NULL, 1, 0,
       0, 10, 30, 0, 0,
       1, 'medium', 'CIP', 'pump', 48, 1, 'Sandbox.'
WHERE NOT EXISTS (SELECT 1 FROM tra_products WHERE product_code = 'FOOD-001');

INSERT INTO tra_products (
  product_id, product_code, product_name, commercial_name, category_id,
  density_kg_l, adr_required, adr_class, food_grade_required, feed_grade_required,
  sandach_required, temperature_min_c, temperature_max_c, needs_heating, needs_cooling,
  needs_bacteriological_filter, viscosity_level, cleaning_level_required,
  discharge_type_required, default_max_transport_hours, active, notes
)
SELECT UUID(), 'FOOD-002', 'Aceite oliva suave', 'Aceite oliva suave', @cat_food_simple,
       0.92, 0, NULL, 1, 0,
       0, 10, 30, 0, 0,
       1, 'medium', 'CIP', 'pump', 48, 1, 'Sandbox.'
WHERE NOT EXISTS (SELECT 1 FROM tra_products WHERE product_code = 'FOOD-002');

INSERT INTO tra_products (
  product_id, product_code, product_name, commercial_name, category_id,
  density_kg_l, adr_required, adr_class, food_grade_required, feed_grade_required,
  sandach_required, temperature_min_c, temperature_max_c, needs_heating, needs_cooling,
  needs_bacteriological_filter, viscosity_level, cleaning_level_required,
  discharge_type_required, default_max_transport_hours, active, notes
)
SELECT UUID(), 'FOOD-003', 'Vino blanco', 'Vino blanco', @cat_food_simple,
       0.99, 0, NULL, 1, 0,
       0, 8, 20, 0, 0,
       1, 'low', 'CIP', 'pump', 72, 1, 'Sandbox.'
WHERE NOT EXISTS (SELECT 1 FROM tra_products WHERE product_code = 'FOOD-003');

INSERT INTO tra_products (
  product_id, product_code, product_name, commercial_name, category_id,
  density_kg_l, adr_required, adr_class, food_grade_required, feed_grade_required,
  sandach_required, temperature_min_c, temperature_max_c, needs_heating, needs_cooling,
  needs_bacteriological_filter, viscosity_level, cleaning_level_required,
  discharge_type_required, default_max_transport_hours, active, notes
)
SELECT UUID(), 'FOOD-004', 'Vino tinto', 'Vino tinto', @cat_food_simple,
       0.99, 0, NULL, 1, 0,
       0, 8, 20, 0, 0,
       1, 'low', 'CIP', 'pump', 72, 1, 'Sandbox.'
WHERE NOT EXISTS (SELECT 1 FROM tra_products WHERE product_code = 'FOOD-004');

INSERT INTO tra_products (
  product_id, product_code, product_name, commercial_name, category_id,
  density_kg_l, adr_required, adr_class, food_grade_required, feed_grade_required,
  sandach_required, temperature_min_c, temperature_max_c, needs_heating, needs_cooling,
  needs_bacteriological_filter, viscosity_level, cleaning_level_required,
  discharge_type_required, default_max_transport_hours, active, notes
)
SELECT UUID(), 'FOOD-005', 'Zumo manzana', 'Zumo manzana', @cat_food_simple,
       1.05, 0, NULL, 1, 0,
       0, 2, 8, 0, 1,
       1, 'medium', 'CIP', 'pump', 24, 1, 'Sandbox.'
WHERE NOT EXISTS (SELECT 1 FROM tra_products WHERE product_code = 'FOOD-005');

INSERT INTO tra_products (
  product_id, product_code, product_name, commercial_name, category_id,
  density_kg_l, adr_required, adr_class, food_grade_required, feed_grade_required,
  sandach_required, temperature_min_c, temperature_max_c, needs_heating, needs_cooling,
  needs_bacteriological_filter, viscosity_level, cleaning_level_required,
  discharge_type_required, default_max_transport_hours, active, notes
)
SELECT UUID(), 'FOOD-006', 'Zumo naranja', 'Zumo naranja', @cat_food_simple,
       1.05, 0, NULL, 1, 0,
       0, 2, 8, 0, 1,
       1, 'medium', 'CIP', 'pump', 24, 1, 'Sandbox.'
WHERE NOT EXISTS (SELECT 1 FROM tra_products WHERE product_code = 'FOOD-006');

INSERT INTO tra_products (
  product_id, product_code, product_name, commercial_name, category_id,
  density_kg_l, adr_required, adr_class, food_grade_required, feed_grade_required,
  sandach_required, temperature_min_c, temperature_max_c, needs_heating, needs_cooling,
  needs_bacteriological_filter, viscosity_level, cleaning_level_required,
  discharge_type_required, default_max_transport_hours, active, notes
)
SELECT UUID(), 'FOOD-007', 'Tomate triturado', 'Tomate triturado', @cat_food_simple,
       1.04, 0, NULL, 1, 0,
       0, 4, 20, 0, 0,
       1, 'medium', 'CIP', 'pump', 48, 1, 'Sandbox.'
WHERE NOT EXISTS (SELECT 1 FROM tra_products WHERE product_code = 'FOOD-007');

INSERT INTO tra_products (
  product_id, product_code, product_name, commercial_name, category_id,
  density_kg_l, adr_required, adr_class, food_grade_required, feed_grade_required,
  sandach_required, temperature_min_c, temperature_max_c, needs_heating, needs_cooling,
  needs_bacteriological_filter, viscosity_level, cleaning_level_required,
  discharge_type_required, default_max_transport_hours, active, notes
)
SELECT UUID(), 'FOOD-008', 'Salsa base', 'Salsa base', @cat_food_simple,
       1.05, 0, NULL, 1, 0,
       0, 4, 20, 0, 0,
       1, 'medium', 'CIP', 'pump', 48, 1, 'Sandbox.'
WHERE NOT EXISTS (SELECT 1 FROM tra_products WHERE product_code = 'FOOD-008');

INSERT INTO tra_products (
  product_id, product_code, product_name, commercial_name, category_id,
  density_kg_l, adr_required, adr_class, food_grade_required, feed_grade_required,
  sandach_required, temperature_min_c, temperature_max_c, needs_heating, needs_cooling,
  needs_bacteriological_filter, viscosity_level, cleaning_level_required,
  discharge_type_required, default_max_transport_hours, active, notes
)
SELECT UUID(), 'FOOD-009', 'Leche semidesnatada', 'Leche semidesnatada', @cat_food_simple,
       1.02, 0, NULL, 1, 0,
       0, 2, 6, 0, 1,
       1, 'low', 'CIP', 'pump', 24, 1, 'Sandbox.'
WHERE NOT EXISTS (SELECT 1 FROM tra_products WHERE product_code = 'FOOD-009');

INSERT INTO tra_products (
  product_id, product_code, product_name, commercial_name, category_id,
  density_kg_l, adr_required, adr_class, food_grade_required, feed_grade_required,
  sandach_required, temperature_min_c, temperature_max_c, needs_heating, needs_cooling,
  needs_bacteriological_filter, viscosity_level, cleaning_level_required,
  discharge_type_required, default_max_transport_hours, active, notes
)
SELECT UUID(), 'FOOD-010', 'Leche deslactosada', 'Leche deslactosada', @cat_food_simple,
       1.02, 0, NULL, 1, 0,
       0, 2, 6, 0, 1,
       1, 'low', 'CIP', 'pump', 24, 1, 'Sandbox.'
WHERE NOT EXISTS (SELECT 1 FROM tra_products WHERE product_code = 'FOOD-010');

-- FEED (8)
INSERT INTO tra_products (
  product_id, product_code, product_name, commercial_name, category_id,
  density_kg_l, adr_required, adr_class, food_grade_required, feed_grade_required,
  sandach_required, temperature_min_c, temperature_max_c, needs_heating, needs_cooling,
  needs_bacteriological_filter, viscosity_level, cleaning_level_required,
  discharge_type_required, default_max_transport_hours, active, notes
)
SELECT UUID(), 'FEED-001', 'Melaza', 'Melaza', @cat_feed,
       1.35, 0, NULL, 0, 1,
       0, 10, 30, 0, 0,
       0, 'high', 'STANDARD', 'pump', 48, 1, 'Sandbox.'
WHERE NOT EXISTS (SELECT 1 FROM tra_products WHERE product_code = 'FEED-001');

INSERT INTO tra_products (
  product_id, product_code, product_name, commercial_name, category_id,
  density_kg_l, adr_required, adr_class, food_grade_required, feed_grade_required,
  sandach_required, temperature_min_c, temperature_max_c, needs_heating, needs_cooling,
  needs_bacteriological_filter, viscosity_level, cleaning_level_required,
  discharge_type_required, default_max_transport_hours, active, notes
)
SELECT UUID(), 'FEED-002', 'Lactosuero feed', 'Lactosuero feed', @cat_feed,
       1.03, 0, NULL, 0, 1,
       0, 4, 12, 0, 0,
       0, 'low', 'STANDARD', 'pump', 48, 1, 'Sandbox.'
WHERE NOT EXISTS (SELECT 1 FROM tra_products WHERE product_code = 'FEED-002');

INSERT INTO tra_products (
  product_id, product_code, product_name, commercial_name, category_id,
  density_kg_l, adr_required, adr_class, food_grade_required, feed_grade_required,
  sandach_required, temperature_min_c, temperature_max_c, needs_heating, needs_cooling,
  needs_bacteriological_filter, viscosity_level, cleaning_level_required,
  discharge_type_required, default_max_transport_hours, active, notes
)
SELECT UUID(), 'FEED-003', 'Grasa animal', 'Grasa animal', @cat_feed,
       0.95, 0, NULL, 0, 1,
       0, 10, 30, 0, 0,
       0, 'medium', 'STANDARD', 'pump', 48, 1, 'Sandbox.'
WHERE NOT EXISTS (SELECT 1 FROM tra_products WHERE product_code = 'FEED-003');

INSERT INTO tra_products (
  product_id, product_code, product_name, commercial_name, category_id,
  density_kg_l, adr_required, adr_class, food_grade_required, feed_grade_required,
  sandach_required, temperature_min_c, temperature_max_c, needs_heating, needs_cooling,
  needs_bacteriological_filter, viscosity_level, cleaning_level_required,
  discharge_type_required, default_max_transport_hours, active, notes
)
SELECT UUID(), 'FEED-004', 'Harina liquida', 'Harina liquida', @cat_feed,
       1.20, 0, NULL, 0, 1,
       0, 10, 30, 0, 0,
       0, 'high', 'STANDARD', 'pump', 48, 1, 'Sandbox.'
WHERE NOT EXISTS (SELECT 1 FROM tra_products WHERE product_code = 'FEED-004');

INSERT INTO tra_products (
  product_id, product_code, product_name, commercial_name, category_id,
  density_kg_l, adr_required, adr_class, food_grade_required, feed_grade_required,
  sandach_required, temperature_min_c, temperature_max_c, needs_heating, needs_cooling,
  needs_bacteriological_filter, viscosity_level, cleaning_level_required,
  discharge_type_required, default_max_transport_hours, active, notes
)
SELECT UUID(), 'FEED-005', 'Suero feed', 'Suero feed', @cat_feed,
       1.02, 0, NULL, 0, 1,
       0, 4, 12, 0, 0,
       0, 'low', 'STANDARD', 'pump', 48, 1, 'Sandbox.'
WHERE NOT EXISTS (SELECT 1 FROM tra_products WHERE product_code = 'FEED-005');

INSERT INTO tra_products (
  product_id, product_code, product_name, commercial_name, category_id,
  density_kg_l, adr_required, adr_class, food_grade_required, feed_grade_required,
  sandach_required, temperature_min_c, temperature_max_c, needs_heating, needs_cooling,
  needs_bacteriological_filter, viscosity_level, cleaning_level_required,
  discharge_type_required, default_max_transport_hours, active, notes
)
SELECT UUID(), 'FEED-006', 'Aceite pescado', 'Aceite pescado', @cat_feed,
       0.92, 0, NULL, 0, 1,
       0, 10, 30, 0, 0,
       0, 'medium', 'STANDARD', 'pump', 48, 1, 'Sandbox.'
WHERE NOT EXISTS (SELECT 1 FROM tra_products WHERE product_code = 'FEED-006');

INSERT INTO tra_products (
  product_id, product_code, product_name, commercial_name, category_id,
  density_kg_l, adr_required, adr_class, food_grade_required, feed_grade_required,
  sandach_required, temperature_min_c, temperature_max_c, needs_heating, needs_cooling,
  needs_bacteriological_filter, viscosity_level, cleaning_level_required,
  discharge_type_required, default_max_transport_hours, active, notes
)
SELECT UUID(), 'FEED-007', 'Solucion vitaminas', 'Solucion vitaminas', @cat_feed,
       1.05, 0, NULL, 0, 1,
       0, 4, 20, 0, 0,
       0, 'low', 'STANDARD', 'pump', 48, 1, 'Sandbox.'
WHERE NOT EXISTS (SELECT 1 FROM tra_products WHERE product_code = 'FEED-007');

INSERT INTO tra_products (
  product_id, product_code, product_name, commercial_name, category_id,
  density_kg_l, adr_required, adr_class, food_grade_required, feed_grade_required,
  sandach_required, temperature_min_c, temperature_max_c, needs_heating, needs_cooling,
  needs_bacteriological_filter, viscosity_level, cleaning_level_required,
  discharge_type_required, default_max_transport_hours, active, notes
)
SELECT UUID(), 'FEED-008', 'Jarabe feed', 'Jarabe feed', @cat_feed,
       1.25, 0, NULL, 0, 1,
       0, 10, 30, 0, 0,
       0, 'high', 'STANDARD', 'pump', 48, 1, 'Sandbox.'
WHERE NOT EXISTS (SELECT 1 FROM tra_products WHERE product_code = 'FEED-008');

-- IND_LIQ (8)
INSERT INTO tra_products (
  product_id, product_code, product_name, commercial_name, category_id,
  density_kg_l, adr_required, adr_class, food_grade_required, feed_grade_required,
  sandach_required, temperature_min_c, temperature_max_c, needs_heating, needs_cooling,
  needs_bacteriological_filter, viscosity_level, cleaning_level_required,
  discharge_type_required, default_max_transport_hours, active, notes
)
SELECT UUID(), 'IND-001', 'Propilenglicol', 'Propilenglicol', @cat_ind,
       1.04, 0, NULL, 0, 0,
       0, 5, 30, 0, 0,
       0, 'medium', 'STANDARD', 'pump', 72, 1, 'Sandbox.'
WHERE NOT EXISTS (SELECT 1 FROM tra_products WHERE product_code = 'IND-001');

INSERT INTO tra_products (
  product_id, product_code, product_name, commercial_name, category_id,
  density_kg_l, adr_required, adr_class, food_grade_required, feed_grade_required,
  sandach_required, temperature_min_c, temperature_max_c, needs_heating, needs_cooling,
  needs_bacteriological_filter, viscosity_level, cleaning_level_required,
  discharge_type_required, default_max_transport_hours, active, notes
)
SELECT UUID(), 'IND-002', 'Aceite mineral', 'Aceite mineral', @cat_ind,
       0.90, 0, NULL, 0, 0,
       0, 5, 30, 0, 0,
       0, 'medium', 'STANDARD', 'pump', 72, 1, 'Sandbox.'
WHERE NOT EXISTS (SELECT 1 FROM tra_products WHERE product_code = 'IND-002');

INSERT INTO tra_products (
  product_id, product_code, product_name, commercial_name, category_id,
  density_kg_l, adr_required, adr_class, food_grade_required, feed_grade_required,
  sandach_required, temperature_min_c, temperature_max_c, needs_heating, needs_cooling,
  needs_bacteriological_filter, viscosity_level, cleaning_level_required,
  discharge_type_required, default_max_transport_hours, active, notes
)
SELECT UUID(), 'IND-003', 'Detergente industrial', 'Detergente industrial', @cat_ind,
       1.05, 0, NULL, 0, 0,
       0, 5, 35, 0, 0,
       0, 'low', 'STANDARD', 'pump', 72, 1, 'Sandbox.'
WHERE NOT EXISTS (SELECT 1 FROM tra_products WHERE product_code = 'IND-003');

INSERT INTO tra_products (
  product_id, product_code, product_name, commercial_name, category_id,
  density_kg_l, adr_required, adr_class, food_grade_required, feed_grade_required,
  sandach_required, temperature_min_c, temperature_max_c, needs_heating, needs_cooling,
  needs_bacteriological_filter, viscosity_level, cleaning_level_required,
  discharge_type_required, default_max_transport_hours, active, notes
)
SELECT UUID(), 'IND-004', 'Resina liquida', 'Resina liquida', @cat_ind,
       1.10, 0, NULL, 0, 0,
       0, 5, 35, 0, 0,
       0, 'high', 'STANDARD', 'pump', 72, 1, 'Sandbox.'
WHERE NOT EXISTS (SELECT 1 FROM tra_products WHERE product_code = 'IND-004');

INSERT INTO tra_products (
  product_id, product_code, product_name, commercial_name, category_id,
  density_kg_l, adr_required, adr_class, food_grade_required, feed_grade_required,
  sandach_required, temperature_min_c, temperature_max_c, needs_heating, needs_cooling,
  needs_bacteriological_filter, viscosity_level, cleaning_level_required,
  discharge_type_required, default_max_transport_hours, active, notes
)
SELECT UUID(), 'IND-005', 'Latex', 'Latex', @cat_ind,
       1.02, 0, NULL, 0, 0,
       0, 5, 30, 0, 0,
       0, 'medium', 'STANDARD', 'pump', 72, 1, 'Sandbox.'
WHERE NOT EXISTS (SELECT 1 FROM tra_products WHERE product_code = 'IND-005');

INSERT INTO tra_products (
  product_id, product_code, product_name, commercial_name, category_id,
  density_kg_l, adr_required, adr_class, food_grade_required, feed_grade_required,
  sandach_required, temperature_min_c, temperature_max_c, needs_heating, needs_cooling,
  needs_bacteriological_filter, viscosity_level, cleaning_level_required,
  discharge_type_required, default_max_transport_hours, active, notes
)
SELECT UUID(), 'IND-006', 'Lubricante', 'Lubricante', @cat_ind,
       0.92, 0, NULL, 0, 0,
       0, 5, 30, 0, 0,
       0, 'medium', 'STANDARD', 'pump', 72, 1, 'Sandbox.'
WHERE NOT EXISTS (SELECT 1 FROM tra_products WHERE product_code = 'IND-006');

INSERT INTO tra_products (
  product_id, product_code, product_name, commercial_name, category_id,
  density_kg_l, adr_required, adr_class, food_grade_required, feed_grade_required,
  sandach_required, temperature_min_c, temperature_max_c, needs_heating, needs_cooling,
  needs_bacteriological_filter, viscosity_level, cleaning_level_required,
  discharge_type_required, default_max_transport_hours, active, notes
)
SELECT UUID(), 'IND-007', 'Solvente base', 'Solvente base', @cat_ind,
       0.88, 0, NULL, 0, 0,
       0, 5, 30, 0, 0,
       0, 'low', 'STANDARD', 'pump', 72, 1, 'Sandbox.'
WHERE NOT EXISTS (SELECT 1 FROM tra_products WHERE product_code = 'IND-007');

INSERT INTO tra_products (
  product_id, product_code, product_name, commercial_name, category_id,
  density_kg_l, adr_required, adr_class, food_grade_required, feed_grade_required,
  sandach_required, temperature_min_c, temperature_max_c, needs_heating, needs_cooling,
  needs_bacteriological_filter, viscosity_level, cleaning_level_required,
  discharge_type_required, default_max_transport_hours, active, notes
)
SELECT UUID(), 'IND-008', 'Agua desionizada', 'Agua desionizada', @cat_ind,
       1.00, 0, NULL, 0, 0,
       0, 4, 20, 0, 0,
       0, 'low', 'STANDARD', 'pump', 72, 1, 'Sandbox.'
WHERE NOT EXISTS (SELECT 1 FROM tra_products WHERE product_code = 'IND-008');

-- ADR_LIQ (6)
INSERT INTO tra_products (
  product_id, product_code, product_name, commercial_name, category_id,
  density_kg_l, adr_required, adr_class, food_grade_required, feed_grade_required,
  sandach_required, temperature_min_c, temperature_max_c, needs_heating, needs_cooling,
  needs_bacteriological_filter, viscosity_level, cleaning_level_required,
  discharge_type_required, default_max_transport_hours, active, notes
)
SELECT UUID(), 'ADR-001', 'Acido sulfurico', 'Acido sulfurico', @cat_adr,
       1.84, 1, '8', 0, 0,
       0, 5, 30, 0, 0,
       0, 'high', 'ADR', 'pump', 48, 1, 'Sandbox.'
WHERE NOT EXISTS (SELECT 1 FROM tra_products WHERE product_code = 'ADR-001');

INSERT INTO tra_products (
  product_id, product_code, product_name, commercial_name, category_id,
  density_kg_l, adr_required, adr_class, food_grade_required, feed_grade_required,
  sandach_required, temperature_min_c, temperature_max_c, needs_heating, needs_cooling,
  needs_bacteriological_filter, viscosity_level, cleaning_level_required,
  discharge_type_required, default_max_transport_hours, active, notes
)
SELECT UUID(), 'ADR-002', 'Acido clorhidrico', 'Acido clorhidrico', @cat_adr,
       1.19, 1, '8', 0, 0,
       0, 5, 30, 0, 0,
       0, 'medium', 'ADR', 'pump', 48, 1, 'Sandbox.'
WHERE NOT EXISTS (SELECT 1 FROM tra_products WHERE product_code = 'ADR-002');

INSERT INTO tra_products (
  product_id, product_code, product_name, commercial_name, category_id,
  density_kg_l, adr_required, adr_class, food_grade_required, feed_grade_required,
  sandach_required, temperature_min_c, temperature_max_c, needs_heating, needs_cooling,
  needs_bacteriological_filter, viscosity_level, cleaning_level_required,
  discharge_type_required, default_max_transport_hours, active, notes
)
SELECT UUID(), 'ADR-003', 'Peroxido hidrogeno', 'Peroxido hidrogeno', @cat_adr,
       1.13, 1, '5.1', 0, 0,
       0, 5, 25, 0, 0,
       0, 'low', 'ADR', 'pump', 48, 1, 'Sandbox.'
WHERE NOT EXISTS (SELECT 1 FROM tra_products WHERE product_code = 'ADR-003');

INSERT INTO tra_products (
  product_id, product_code, product_name, commercial_name, category_id,
  density_kg_l, adr_required, adr_class, food_grade_required, feed_grade_required,
  sandach_required, temperature_min_c, temperature_max_c, needs_heating, needs_cooling,
  needs_bacteriological_filter, viscosity_level, cleaning_level_required,
  discharge_type_required, default_max_transport_hours, active, notes
)
SELECT UUID(), 'ADR-004', 'Metanol', 'Metanol', @cat_adr,
       0.79, 1, '3', 0, 0,
       0, 5, 30, 0, 0,
       0, 'low', 'ADR', 'pump', 48, 1, 'Sandbox.'
WHERE NOT EXISTS (SELECT 1 FROM tra_products WHERE product_code = 'ADR-004');

INSERT INTO tra_products (
  product_id, product_code, product_name, commercial_name, category_id,
  density_kg_l, adr_required, adr_class, food_grade_required, feed_grade_required,
  sandach_required, temperature_min_c, temperature_max_c, needs_heating, needs_cooling,
  needs_bacteriological_filter, viscosity_level, cleaning_level_required,
  discharge_type_required, default_max_transport_hours, active, notes
)
SELECT UUID(), 'ADR-005', 'Etil acetato', 'Etil acetato', @cat_adr,
       0.90, 1, '3', 0, 0,
       0, 5, 30, 0, 0,
       0, 'low', 'ADR', 'pump', 48, 1, 'Sandbox.'
WHERE NOT EXISTS (SELECT 1 FROM tra_products WHERE product_code = 'ADR-005');

INSERT INTO tra_products (
  product_id, product_code, product_name, commercial_name, category_id,
  density_kg_l, adr_required, adr_class, food_grade_required, feed_grade_required,
  sandach_required, temperature_min_c, temperature_max_c, needs_heating, needs_cooling,
  needs_bacteriological_filter, viscosity_level, cleaning_level_required,
  discharge_type_required, default_max_transport_hours, active, notes
)
SELECT UUID(), 'ADR-006', 'Acetona', 'Acetona', @cat_adr,
       0.79, 1, '3', 0, 0,
       0, 5, 30, 0, 0,
       0, 'low', 'ADR', 'pump', 48, 1, 'Sandbox.'
WHERE NOT EXISTS (SELECT 1 FROM tra_products WHERE product_code = 'ADR-006');

-- C3 (8)
INSERT INTO tra_products (
  product_id, product_code, product_name, commercial_name, category_id,
  density_kg_l, adr_required, adr_class, food_grade_required, feed_grade_required,
  sandach_required, temperature_min_c, temperature_max_c, needs_heating, needs_cooling,
  needs_bacteriological_filter, viscosity_level, cleaning_level_required,
  discharge_type_required, default_max_transport_hours, active, notes
)
SELECT UUID(), 'C3-001', 'Lodo tecnico', 'Lodo tecnico', @cat_c3,
       1.10, 0, NULL, 0, 0,
       0, 4, 30, 0, 0,
       0, 'high', 'STANDARD', 'pump', 48, 1, 'Sandbox.'
WHERE NOT EXISTS (SELECT 1 FROM tra_products WHERE product_code = 'C3-001');

INSERT INTO tra_products (
  product_id, product_code, product_name, commercial_name, category_id,
  density_kg_l, adr_required, adr_class, food_grade_required, feed_grade_required,
  sandach_required, temperature_min_c, temperature_max_c, needs_heating, needs_cooling,
  needs_bacteriological_filter, viscosity_level, cleaning_level_required,
  discharge_type_required, default_max_transport_hours, active, notes
)
SELECT UUID(), 'C3-002', 'Aceite usado', 'Aceite usado', @cat_c3,
       0.92, 0, NULL, 0, 0,
       0, 4, 30, 0, 0,
       0, 'medium', 'STANDARD', 'pump', 48, 1, 'Sandbox.'
WHERE NOT EXISTS (SELECT 1 FROM tra_products WHERE product_code = 'C3-002');

INSERT INTO tra_products (
  product_id, product_code, product_name, commercial_name, category_id,
  density_kg_l, adr_required, adr_class, food_grade_required, feed_grade_required,
  sandach_required, temperature_min_c, temperature_max_c, needs_heating, needs_cooling,
  needs_bacteriological_filter, viscosity_level, cleaning_level_required,
  discharge_type_required, default_max_transport_hours, active, notes
)
SELECT UUID(), 'C3-003', 'Glicol usado', 'Glicol usado', @cat_c3,
       1.05, 0, NULL, 0, 0,
       0, 4, 30, 0, 0,
       0, 'medium', 'STANDARD', 'pump', 48, 1, 'Sandbox.'
WHERE NOT EXISTS (SELECT 1 FROM tra_products WHERE product_code = 'C3-003');

INSERT INTO tra_products (
  product_id, product_code, product_name, commercial_name, category_id,
  density_kg_l, adr_required, adr_class, food_grade_required, feed_grade_required,
  sandach_required, temperature_min_c, temperature_max_c, needs_heating, needs_cooling,
  needs_bacteriological_filter, viscosity_level, cleaning_level_required,
  discharge_type_required, default_max_transport_hours, active, notes
)
SELECT UUID(), 'C3-004', 'Emulsion tecnica', 'Emulsion tecnica', @cat_c3,
       1.00, 0, NULL, 0, 0,
       0, 4, 30, 0, 0,
       0, 'low', 'STANDARD', 'pump', 48, 1, 'Sandbox.'
WHERE NOT EXISTS (SELECT 1 FROM tra_products WHERE product_code = 'C3-004');

INSERT INTO tra_products (
  product_id, product_code, product_name, commercial_name, category_id,
  density_kg_l, adr_required, adr_class, food_grade_required, feed_grade_required,
  sandach_required, temperature_min_c, temperature_max_c, needs_heating, needs_cooling,
  needs_bacteriological_filter, viscosity_level, cleaning_level_required,
  discharge_type_required, default_max_transport_hours, active, notes
)
SELECT UUID(), 'C3-005', 'Lavado CIP usado', 'Lavado CIP usado', @cat_c3,
       1.00, 0, NULL, 0, 0,
       0, 4, 30, 0, 0,
       0, 'low', 'STANDARD', 'pump', 48, 1, 'Sandbox.'
WHERE NOT EXISTS (SELECT 1 FROM tra_products WHERE product_code = 'C3-005');

INSERT INTO tra_products (
  product_id, product_code, product_name, commercial_name, category_id,
  density_kg_l, adr_required, adr_class, food_grade_required, feed_grade_required,
  sandach_required, temperature_min_c, temperature_max_c, needs_heating, needs_cooling,
  needs_bacteriological_filter, viscosity_level, cleaning_level_required,
  discharge_type_required, default_max_transport_hours, active, notes
)
SELECT UUID(), 'C3-006', 'Solucion tecnica', 'Solucion tecnica', @cat_c3,
       1.00, 0, NULL, 0, 0,
       0, 4, 30, 0, 0,
       0, 'low', 'STANDARD', 'pump', 48, 1, 'Sandbox.'
WHERE NOT EXISTS (SELECT 1 FROM tra_products WHERE product_code = 'C3-006');

INSERT INTO tra_products (
  product_id, product_code, product_name, commercial_name, category_id,
  density_kg_l, adr_required, adr_class, food_grade_required, feed_grade_required,
  sandach_required, temperature_min_c, temperature_max_c, needs_heating, needs_cooling,
  needs_bacteriological_filter, viscosity_level, cleaning_level_required,
  discharge_type_required, default_max_transport_hours, active, notes
)
SELECT UUID(), 'C3-007', 'Liquido C3', 'Liquido C3', @cat_c3,
       1.00, 0, NULL, 0, 0,
       0, 4, 30, 0, 0,
       0, 'low', 'STANDARD', 'pump', 48, 1, 'Sandbox.'
WHERE NOT EXISTS (SELECT 1 FROM tra_products WHERE product_code = 'C3-007');

INSERT INTO tra_products (
  product_id, product_code, product_name, commercial_name, category_id,
  density_kg_l, adr_required, adr_class, food_grade_required, feed_grade_required,
  sandach_required, temperature_min_c, temperature_max_c, needs_heating, needs_cooling,
  needs_bacteriological_filter, viscosity_level, cleaning_level_required,
  discharge_type_required, default_max_transport_hours, active, notes
)
SELECT UUID(), 'C3-008', 'Agua residual', 'Agua residual', @cat_c3,
       1.00, 0, NULL, 0, 0,
       0, 4, 30, 0, 0,
       0, 'low', 'STANDARD', 'pump', 48, 1, 'Sandbox.'
WHERE NOT EXISTS (SELECT 1 FROM tra_products WHERE product_code = 'C3-008');

-- =========================
-- Tanques
-- =========================
SET @tank_004 := (SELECT tank_id FROM tra_tanks WHERE tank_code = 'TNK-004' LIMIT 1);
SET @tank_004 := IFNULL(@tank_004, 'b6d3007c-26d5-11f1-9b4a-5a0d05a37ed2');
INSERT INTO tra_tanks (
  tank_id, tank_code, tank_type, capacity_liters, max_payload_tn,
  temperature_control, heating_system, cooling_system, self_unloading,
  bacteriological_filter, compartment_count, dedicated_use, cleaning_status,
  current_location, ownership_type, active, last_cleaning_date, created_at, updated_at, notes
)
SELECT @tank_004, 'TNK-004', 'food_grade', 32000, 26.00,
       1, 0, 1, 1,
       1, 4, 'milk', 'clean',
       NULL, 'owned', 1, NULL, NOW(), NOW(), 'Food grade para lácteos.'
WHERE NOT EXISTS (SELECT 1 FROM tra_tanks WHERE tank_code = 'TNK-004');

SET @tank_005 := (SELECT tank_id FROM tra_tanks WHERE tank_code = 'TNK-005' LIMIT 1);
SET @tank_005 := IFNULL(@tank_005, 'b6d3018c-26d5-11f1-9b4a-5a0d05a37ed2');
INSERT INTO tra_tanks (
  tank_id, tank_code, tank_type, capacity_liters, max_payload_tn,
  temperature_control, heating_system, cooling_system, self_unloading,
  bacteriological_filter, compartment_count, dedicated_use, cleaning_status,
  current_location, ownership_type, active, last_cleaning_date, created_at, updated_at, notes
)
SELECT @tank_005, 'TNK-005', 'standard', 24000, 22.00,
       0, 0, 0, 1,
       0, 2, NULL, 'clean',
       NULL, 'leased', 1, NULL, NOW(), NOW(), 'Uso general.'
WHERE NOT EXISTS (SELECT 1 FROM tra_tanks WHERE tank_code = 'TNK-005');

SET @tank_006 := (SELECT tank_id FROM tra_tanks WHERE tank_code = 'TNK-006' LIMIT 1);
SET @tank_006 := IFNULL(@tank_006, 'b6d3029a-26d5-11f1-9b4a-5a0d05a37ed2');
INSERT INTO tra_tanks (
  tank_id, tank_code, tank_type, capacity_liters, max_payload_tn,
  temperature_control, heating_system, cooling_system, self_unloading,
  bacteriological_filter, compartment_count, dedicated_use, cleaning_status,
  current_location, ownership_type, active, last_cleaning_date, created_at, updated_at, notes
)
SELECT @tank_006, 'TNK-006', 'adr', 20000, 20.00,
       0, 0, 0, 1,
       0, 3, NULL, 'clean',
       NULL, 'owned', 1, NULL, NOW(), NOW(), 'Tanque ADR.'
WHERE NOT EXISTS (SELECT 1 FROM tra_tanks WHERE tank_code = 'TNK-006');

-- =========================
-- Autorizaciones tanque-producto
-- =========================
INSERT INTO tra_tank_product_authorizations (
  tank_product_authorization_id, tank_id, category_id, product_id,
  allowed, authorization_type, restriction_notes, valid_from, valid_to, created_at, updated_at
)
SELECT UUID(), @tank_004, @cat_food, NULL,
       1, 'category', 'Apto para alimentarios', NULL, NULL, NOW(), NOW()
WHERE NOT EXISTS (
  SELECT 1 FROM tra_tank_product_authorizations
  WHERE tank_id = @tank_004 AND category_id = @cat_food AND product_id IS NULL
);

INSERT INTO tra_tank_product_authorizations (
  tank_product_authorization_id, tank_id, category_id, product_id,
  allowed, authorization_type, restriction_notes, valid_from, valid_to, created_at, updated_at
)
SELECT UUID(), @tank_005, @cat_ind, NULL,
       1, 'category', 'Uso industrial', NULL, NULL, NOW(), NOW()
WHERE NOT EXISTS (
  SELECT 1 FROM tra_tank_product_authorizations
  WHERE tank_id = @tank_005 AND category_id = @cat_ind AND product_id IS NULL
);

INSERT INTO tra_tank_product_authorizations (
  tank_product_authorization_id, tank_id, category_id, product_id,
  allowed, authorization_type, restriction_notes, valid_from, valid_to, created_at, updated_at
)
SELECT UUID(), @tank_006, @cat_adr, @prod_naoh,
       1, 'product', 'ADR clase 8', NULL, NULL, NOW(), NOW()
WHERE NOT EXISTS (
  SELECT 1 FROM tra_tank_product_authorizations
  WHERE tank_id = @tank_006 AND product_id = @prod_naoh
);

-- =========================
-- Vehículos
-- =========================
SET @veh_004 := (SELECT vehicle_id FROM tra_vehicles WHERE vehicle_code = 'VEH-004' LIMIT 1);
SET @veh_004 := IFNULL(@veh_004, 'b6d3108e-26d5-11f1-9b4a-5a0d05a37ed2');
INSERT INTO tra_vehicles (
  vehicle_id, vehicle_code, plate_number, vehicle_type, home_base,
  euro_class, max_daily_km, max_weekly_km, gps_enabled, intermodal_capable,
  maintenance_status, last_maintenance_date, next_maintenance_date, active, created_at, updated_at
)
SELECT @veh_004, 'VEH-004', '2345-BCD', 'CISTERNA_FOOD', 'Barcelona',
       'EURO6', 900, 4000, 1, 0,
       'ok', NULL, NULL, 1, NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM tra_vehicles WHERE vehicle_code = 'VEH-004');

SET @veh_005 := (SELECT vehicle_id FROM tra_vehicles WHERE vehicle_code = 'VEH-005' LIMIT 1);
SET @veh_005 := IFNULL(@veh_005, 'b6d3119c-26d5-11f1-9b4a-5a0d05a37ed2');
INSERT INTO tra_vehicles (
  vehicle_id, vehicle_code, plate_number, vehicle_type, home_base,
  euro_class, max_daily_km, max_weekly_km, gps_enabled, intermodal_capable,
  maintenance_status, last_maintenance_date, next_maintenance_date, active, created_at, updated_at
)
SELECT @veh_005, 'VEH-005', '3456-CDE', 'CISTERNA', 'Madrid',
       'EURO5', 800, 3500, 1, 1,
       'ok', NULL, NULL, 1, NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM tra_vehicles WHERE vehicle_code = 'VEH-005');

SET @veh_006 := (SELECT vehicle_id FROM tra_vehicles WHERE vehicle_code = 'VEH-006' LIMIT 1);
SET @veh_006 := IFNULL(@veh_006, 'b6d312aa-26d5-11f1-9b4a-5a0d05a37ed2');
INSERT INTO tra_vehicles (
  vehicle_id, vehicle_code, plate_number, vehicle_type, home_base,
  euro_class, max_daily_km, max_weekly_km, gps_enabled, intermodal_capable,
  maintenance_status, last_maintenance_date, next_maintenance_date, active, created_at, updated_at
)
SELECT @veh_006, 'VEH-006', '4567-DEF', 'CISTERNA_ADR', 'Valencia',
       'EURO6', 700, 3000, 1, 0,
       'ok', NULL, NULL, 1, NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM tra_vehicles WHERE vehicle_code = 'VEH-006');

-- =========================
-- Disponibilidad de vehículos (mayo y agosto)
-- =========================
INSERT INTO tra_vehicle_availability (
  vehicle_availability_id, vehicle_id, availability_date, available_from,
  available_until, available, unavailability_reason, current_location,
  planned_km_limit, notes, created_at, updated_at
)
SELECT UUID(), @veh_004, '2026-05-12', '06:00:00', '20:00:00', 1, NULL, 'Barcelona', 900, NULL, NOW(), NOW()
WHERE NOT EXISTS (
  SELECT 1 FROM tra_vehicle_availability
  WHERE vehicle_id = @veh_004 AND availability_date = '2026-05-12'
);

INSERT INTO tra_vehicle_availability (
  vehicle_availability_id, vehicle_id, availability_date, available_from,
  available_until, available, unavailability_reason, current_location,
  planned_km_limit, notes, created_at, updated_at
)
SELECT UUID(), @veh_005, '2026-05-12', '06:00:00', '20:00:00', 1, NULL, 'Madrid', 800, NULL, NOW(), NOW()
WHERE NOT EXISTS (
  SELECT 1 FROM tra_vehicle_availability
  WHERE vehicle_id = @veh_005 AND availability_date = '2026-05-12'
);

INSERT INTO tra_vehicle_availability (
  vehicle_availability_id, vehicle_id, availability_date, available_from,
  available_until, available, unavailability_reason, current_location,
  planned_km_limit, notes, created_at, updated_at
)
SELECT UUID(), @veh_006, '2026-05-12', '06:00:00', '20:00:00', 1, NULL, 'Valencia', 700, NULL, NOW(), NOW()
WHERE NOT EXISTS (
  SELECT 1 FROM tra_vehicle_availability
  WHERE vehicle_id = @veh_006 AND availability_date = '2026-05-12'
);

INSERT INTO tra_vehicle_availability (
  vehicle_availability_id, vehicle_id, availability_date, available_from,
  available_until, available, unavailability_reason, current_location,
  planned_km_limit, notes, created_at, updated_at
)
SELECT UUID(), @veh_004, '2026-08-12', '06:00:00', '20:00:00', 1, NULL, 'Barcelona', 900, NULL, NOW(), NOW()
WHERE NOT EXISTS (
  SELECT 1 FROM tra_vehicle_availability
  WHERE vehicle_id = @veh_004 AND availability_date = '2026-08-12'
);

-- =========================
-- Relación vehículo-tanque
-- =========================
INSERT INTO tra_vehicle_tanks (
  vehicle_tank_id, vehicle_id, tank_id, active, valid_from, valid_to, notes, created_at, updated_at
)
SELECT UUID(), @veh_004, @tank_004, 1, NULL, NULL, 'Food grade', NOW(), NOW()
WHERE NOT EXISTS (
  SELECT 1 FROM tra_vehicle_tanks WHERE vehicle_id = @veh_004 AND tank_id = @tank_004
);

INSERT INTO tra_vehicle_tanks (
  vehicle_tank_id, vehicle_id, tank_id, active, valid_from, valid_to, notes, created_at, updated_at
)
SELECT UUID(), @veh_005, @tank_005, 1, NULL, NULL, 'Industrial', NOW(), NOW()
WHERE NOT EXISTS (
  SELECT 1 FROM tra_vehicle_tanks WHERE vehicle_id = @veh_005 AND tank_id = @tank_005
);

INSERT INTO tra_vehicle_tanks (
  vehicle_tank_id, vehicle_id, tank_id, active, valid_from, valid_to, notes, created_at, updated_at
)
SELECT UUID(), @veh_006, @tank_006, 1, NULL, NULL, 'ADR', NOW(), NOW()
WHERE NOT EXISTS (
  SELECT 1 FROM tra_vehicle_tanks WHERE vehicle_id = @veh_006 AND tank_id = @tank_006
);

-- =========================
-- Puntos de carga
-- =========================
SET @lp_bcn := (SELECT loading_point_id FROM tra_loading_points WHERE point_code = 'BCN-PLANT' LIMIT 1);
SET @lp_bcn := IFNULL(@lp_bcn, 'b6d3209e-26d5-11f1-9b4a-5a0d05a37ed2');
INSERT INTO tra_loading_points (
  loading_point_id, client_id, point_code, point_name, country_code, postal_code, city,
  address_line1, latitude, longitude, loading_window_start, loading_window_end,
  loading_days_mask, requires_prealert, access_restrictions, allowed_vehicle_types,
  default_contact_id, active, notes
)
SELECT @lp_bcn, NULL, 'BCN-PLANT', 'Planta Barcelona', 'ES', '08040', 'Barcelona',
       'C/ Logística 1', 41.354, 2.126, '06:00:00', '20:00:00',
       'LMMJV', 0, NULL, 'CISTERNA,CISTERNA_FOOD',
       NULL, 1, 'Acceso 24/7 con cita'
WHERE NOT EXISTS (SELECT 1 FROM tra_loading_points WHERE point_code = 'BCN-PLANT');

SET @lp_zar := (SELECT loading_point_id FROM tra_loading_points WHERE point_code = 'ZAR-PLANT' LIMIT 1);
SET @lp_zar := IFNULL(@lp_zar, 'b6d321ac-26d5-11f1-9b4a-5a0d05a37ed2');
INSERT INTO tra_loading_points (
  loading_point_id, client_id, point_code, point_name, country_code, postal_code, city,
  address_line1, latitude, longitude, loading_window_start, loading_window_end,
  loading_days_mask, requires_prealert, access_restrictions, allowed_vehicle_types,
  default_contact_id, active, notes
)
SELECT @lp_zar, NULL, 'ZAR-PLANT', 'Planta Zaragoza', 'ES', '50003', 'Zaragoza',
       'Av. Industria 45', 41.654, -0.877, '06:00:00', '20:00:00',
       'LMMJV', 0, NULL, 'CISTERNA,CISTERNA_FOOD',
       NULL, 1, NULL
WHERE NOT EXISTS (SELECT 1 FROM tra_loading_points WHERE point_code = 'ZAR-PLANT');

SET @lp_pam := (SELECT loading_point_id FROM tra_loading_points WHERE point_code = 'PAM-PLANT' LIMIT 1);
SET @lp_pam := IFNULL(@lp_pam, 'b6d322ba-26d5-11f1-9b4a-5a0d05a37ed2');
INSERT INTO tra_loading_points (
  loading_point_id, client_id, point_code, point_name, country_code, postal_code, city,
  address_line1, latitude, longitude, loading_window_start, loading_window_end,
  loading_days_mask, requires_prealert, access_restrictions, allowed_vehicle_types,
  default_contact_id, active, notes
)
SELECT @lp_pam, NULL, 'PAM-PLANT', 'Planta Pamplona', 'ES', '31001', 'Pamplona',
       'Pol. Norte 12', 42.816, -1.645, '06:00:00', '20:00:00',
       'LMMJV', 0, NULL, 'CISTERNA,CISTERNA_FOOD',
       NULL, 1, NULL
WHERE NOT EXISTS (SELECT 1 FROM tra_loading_points WHERE point_code = 'PAM-PLANT');

SET @lp_bil := (SELECT loading_point_id FROM tra_loading_points WHERE point_code = 'BIL-PLANT' LIMIT 1);
SET @lp_bil := IFNULL(@lp_bil, 'b6d323c8-26d5-11f1-9b4a-5a0d05a37ed2');
INSERT INTO tra_loading_points (
  loading_point_id, client_id, point_code, point_name, country_code, postal_code, city,
  address_line1, latitude, longitude, loading_window_start, loading_window_end,
  loading_days_mask, requires_prealert, access_restrictions, allowed_vehicle_types,
  default_contact_id, active, notes
)
SELECT @lp_bil, NULL, 'BIL-PLANT', 'Planta Bilbao', 'ES', '48001', 'Bilbao',
       'C/ Puerto 7', 43.263, -2.935, '06:00:00', '20:00:00',
       'LMMJV', 0, NULL, 'CISTERNA,CISTERNA_FOOD',
       NULL, 1, NULL
WHERE NOT EXISTS (SELECT 1 FROM tra_loading_points WHERE point_code = 'BIL-PLANT');

SET @lp_sdr := (SELECT loading_point_id FROM tra_loading_points WHERE point_code = 'SDR-PLANT' LIMIT 1);
SET @lp_sdr := IFNULL(@lp_sdr, 'b6d324d6-26d5-11f1-9b4a-5a0d05a37ed2');
INSERT INTO tra_loading_points (
  loading_point_id, client_id, point_code, point_name, country_code, postal_code, city,
  address_line1, latitude, longitude, loading_window_start, loading_window_end,
  loading_days_mask, requires_prealert, access_restrictions, allowed_vehicle_types,
  default_contact_id, active, notes
)
SELECT @lp_sdr, NULL, 'SDR-PLANT', 'Planta Santander', 'ES', '39001', 'Santander',
       'Av. Marítima 20', 43.462, -3.809, '06:00:00', '20:00:00',
       'LMMJV', 0, NULL, 'CISTERNA,CISTERNA_FOOD',
       NULL, 1, NULL
WHERE NOT EXISTS (SELECT 1 FROM tra_loading_points WHERE point_code = 'SDR-PLANT');

SET @lp_mad := (SELECT loading_point_id FROM tra_loading_points WHERE point_code = 'MAD-PLANT' LIMIT 1);
SET @lp_mad := IFNULL(@lp_mad, 'b6d325e4-26d5-11f1-9b4a-5a0d05a37ed2');
INSERT INTO tra_loading_points (
  loading_point_id, client_id, point_code, point_name, country_code, postal_code, city,
  address_line1, latitude, longitude, loading_window_start, loading_window_end,
  loading_days_mask, requires_prealert, access_restrictions, allowed_vehicle_types,
  default_contact_id, active, notes
)
SELECT @lp_mad, NULL, 'MAD-PLANT', 'Planta Madrid', 'ES', '28021', 'Madrid',
       'C/ Central 10', 40.391, -3.695, '06:00:00', '20:00:00',
       'LMMJV', 0, NULL, 'CISTERNA,CISTERNA_FOOD',
       NULL, 1, NULL
WHERE NOT EXISTS (SELECT 1 FROM tra_loading_points WHERE point_code = 'MAD-PLANT');

SET @lp_mal := (SELECT loading_point_id FROM tra_loading_points WHERE point_code = 'MAL-PLANT' LIMIT 1);
SET @lp_mal := IFNULL(@lp_mal, 'b6d326f2-26d5-11f1-9b4a-5a0d05a37ed2');
INSERT INTO tra_loading_points (
  loading_point_id, client_id, point_code, point_name, country_code, postal_code, city,
  address_line1, latitude, longitude, loading_window_start, loading_window_end,
  loading_days_mask, requires_prealert, access_restrictions, allowed_vehicle_types,
  default_contact_id, active, notes
)
SELECT @lp_mal, NULL, 'MAL-PLANT', 'Planta Málaga', 'ES', '29001', 'Málaga',
       'C/ Puerto 5', 36.721, -4.421, '06:00:00', '20:00:00',
       'LMMJV', 0, NULL, 'CISTERNA,CISTERNA_FOOD',
       NULL, 1, NULL
WHERE NOT EXISTS (SELECT 1 FROM tra_loading_points WHERE point_code = 'MAL-PLANT');

SET @lp_lle := (SELECT loading_point_id FROM tra_loading_points WHERE point_code = 'LLE-PLANT' LIMIT 1);
SET @lp_lle := IFNULL(@lp_lle, 'b6d327fe-26d5-11f1-9b4a-5a0d05a37ed2');
INSERT INTO tra_loading_points (
  loading_point_id, client_id, point_code, point_name, country_code, postal_code, city,
  address_line1, latitude, longitude, loading_window_start, loading_window_end,
  loading_days_mask, requires_prealert, access_restrictions, allowed_vehicle_types,
  default_contact_id, active, notes
)
SELECT @lp_lle, NULL, 'LLE-PLANT', 'Planta Lleida', 'ES', '25001', 'Lleida',
       'C/ Segre 2', 41.617, 0.620, '06:00:00', '20:00:00',
       'LMMJV', 0, NULL, 'CISTERNA,CISTERNA_FOOD',
       NULL, 1, NULL
WHERE NOT EXISTS (SELECT 1 FROM tra_loading_points WHERE point_code = 'LLE-PLANT');

SET @lp_val := (SELECT loading_point_id FROM tra_loading_points WHERE point_code = 'VAL-PLANT' LIMIT 1);
SET @lp_val := IFNULL(@lp_val, 'b6d32914-26d5-11f1-9b4a-5a0d05a37ed2');
INSERT INTO tra_loading_points (
  loading_point_id, client_id, point_code, point_name, country_code, postal_code, city,
  address_line1, latitude, longitude, loading_window_start, loading_window_end,
  loading_days_mask, requires_prealert, access_restrictions, allowed_vehicle_types,
  default_contact_id, active, notes
)
SELECT @lp_val, NULL, 'VAL-PLANT', 'Planta Valencia', 'ES', '46001', 'Valencia',
       'Av. Puerto 21', 39.470, -0.376, '06:00:00', '20:00:00',
       'LMMJV', 0, NULL, 'CISTERNA,CISTERNA_FOOD',
       NULL, 1, NULL
WHERE NOT EXISTS (SELECT 1 FROM tra_loading_points WHERE point_code = 'VAL-PLANT');

-- =========================
-- Puntos de descarga
-- =========================
SET @up_sdr := (SELECT unloading_point_id FROM tra_unloading_points WHERE point_code = 'SDR-DC' LIMIT 1);
SET @up_sdr := IFNULL(@up_sdr, 'b6d33026-26d5-11f1-9b4a-5a0d05a37ed2');
INSERT INTO tra_unloading_points (
  unloading_point_id, client_id, point_code, point_name, country_code, postal_code, city,
  address_line1, latitude, longitude, unloading_window_start, unloading_window_end,
  unloading_days_mask, requires_prealert, discharge_requirements, allowed_vehicle_types,
  default_contact_id, active, notes
)
SELECT @up_sdr, NULL, 'SDR-DC', 'Descarga Santander', 'ES', '39002', 'Santander',
       'Av. Puerto 12', 43.462, -3.809, '06:00:00', '20:00:00',
       'LMMJV', 0, NULL, 'CISTERNA,CISTERNA_FOOD',
       NULL, 1, NULL
WHERE NOT EXISTS (SELECT 1 FROM tra_unloading_points WHERE point_code = 'SDR-DC');

SET @up_mad := (SELECT unloading_point_id FROM tra_unloading_points WHERE point_code = 'MAD-DC' LIMIT 1);
SET @up_mad := IFNULL(@up_mad, 'b6d33134-26d5-11f1-9b4a-5a0d05a37ed2');
INSERT INTO tra_unloading_points (
  unloading_point_id, client_id, point_code, point_name, country_code, postal_code, city,
  address_line1, latitude, longitude, unloading_window_start, unloading_window_end,
  unloading_days_mask, requires_prealert, discharge_requirements, allowed_vehicle_types,
  default_contact_id, active, notes
)
SELECT @up_mad, NULL, 'MAD-DC', 'Descarga Madrid', 'ES', '28021', 'Madrid',
       'C/ Central 20', 40.392, -3.695, '06:00:00', '20:00:00',
       'LMMJV', 0, NULL, 'CISTERNA,CISTERNA_FOOD',
       NULL, 1, NULL
WHERE NOT EXISTS (SELECT 1 FROM tra_unloading_points WHERE point_code = 'MAD-DC');

SET @up_bcn := (SELECT unloading_point_id FROM tra_unloading_points WHERE point_code = 'BCN-DC' LIMIT 1);
SET @up_bcn := IFNULL(@up_bcn, 'b6d33242-26d5-11f1-9b4a-5a0d05a37ed2');
INSERT INTO tra_unloading_points (
  unloading_point_id, client_id, point_code, point_name, country_code, postal_code, city,
  address_line1, latitude, longitude, unloading_window_start, unloading_window_end,
  unloading_days_mask, requires_prealert, discharge_requirements, allowed_vehicle_types,
  default_contact_id, active, notes
)
SELECT @up_bcn, NULL, 'BCN-DC', 'Descarga Barcelona', 'ES', '08040', 'Barcelona',
       'C/ Logística 99', 41.354, 2.126, '06:00:00', '20:00:00',
       'LMMJV', 0, NULL, 'CISTERNA,CISTERNA_FOOD',
       NULL, 1, NULL
WHERE NOT EXISTS (SELECT 1 FROM tra_unloading_points WHERE point_code = 'BCN-DC');

SET @up_mal := (SELECT unloading_point_id FROM tra_unloading_points WHERE point_code = 'MAL-DC' LIMIT 1);
SET @up_mal := IFNULL(@up_mal, 'b6d33350-26d5-11f1-9b4a-5a0d05a37ed2');
INSERT INTO tra_unloading_points (
  unloading_point_id, client_id, point_code, point_name, country_code, postal_code, city,
  address_line1, latitude, longitude, unloading_window_start, unloading_window_end,
  unloading_days_mask, requires_prealert, discharge_requirements, allowed_vehicle_types,
  default_contact_id, active, notes
)
SELECT @up_mal, NULL, 'MAL-DC', 'Descarga Málaga', 'ES', '29002', 'Málaga',
       'C/ Puerto 15', 36.721, -4.421, '06:00:00', '20:00:00',
       'LMMJV', 0, NULL, 'CISTERNA,CISTERNA_FOOD',
       NULL, 1, NULL
WHERE NOT EXISTS (SELECT 1 FROM tra_unloading_points WHERE point_code = 'MAL-DC');

SET @up_lle := (SELECT unloading_point_id FROM tra_unloading_points WHERE point_code = 'LLE-DC' LIMIT 1);
SET @up_lle := IFNULL(@up_lle, 'b6d3345e-26d5-11f1-9b4a-5a0d05a37ed2');
INSERT INTO tra_unloading_points (
  unloading_point_id, client_id, point_code, point_name, country_code, postal_code, city,
  address_line1, latitude, longitude, unloading_window_start, unloading_window_end,
  unloading_days_mask, requires_prealert, discharge_requirements, allowed_vehicle_types,
  default_contact_id, active, notes
)
SELECT @up_lle, NULL, 'LLE-DC', 'Descarga Lleida', 'ES', '25001', 'Lleida',
       'C/ Segre 22', 41.617, 0.620, '06:00:00', '20:00:00',
       'LMMJV', 0, NULL, 'CISTERNA,CISTERNA_FOOD',
       NULL, 1, NULL
WHERE NOT EXISTS (SELECT 1 FROM tra_unloading_points WHERE point_code = 'LLE-DC');

SET @up_mor := (SELECT unloading_point_id FROM tra_unloading_points WHERE point_code = 'MOR-DC' LIMIT 1);
SET @up_mor := IFNULL(@up_mor, 'b6d3356c-26d5-11f1-9b4a-5a0d05a37ed2');
INSERT INTO tra_unloading_points (
  unloading_point_id, client_id, point_code, point_name, country_code, postal_code, city,
  address_line1, latitude, longitude, unloading_window_start, unloading_window_end,
  unloading_days_mask, requires_prealert, discharge_requirements, allowed_vehicle_types,
  default_contact_id, active, notes
)
SELECT @up_mor, NULL, 'MOR-DC', 'Descarga Morón', 'ES', '41530', 'Morón de la Frontera',
       'C/ Prado 5', 37.121, -5.454, '06:00:00', '20:00:00',
       'LMMJV', 0, NULL, 'CISTERNA,CISTERNA_FOOD',
       NULL, 1, NULL
WHERE NOT EXISTS (SELECT 1 FROM tra_unloading_points WHERE point_code = 'MOR-DC');

SET @up_val := (SELECT unloading_point_id FROM tra_unloading_points WHERE point_code = 'VAL-DC' LIMIT 1);
SET @up_val := IFNULL(@up_val, 'b6d3367a-26d5-11f1-9b4a-5a0d05a37ed2');
INSERT INTO tra_unloading_points (
  unloading_point_id, client_id, point_code, point_name, country_code, postal_code, city,
  address_line1, latitude, longitude, unloading_window_start, unloading_window_end,
  unloading_days_mask, requires_prealert, discharge_requirements, allowed_vehicle_types,
  default_contact_id, active, notes
)
SELECT @up_val, NULL, 'VAL-DC', 'Descarga Valencia', 'ES', '46002', 'Valencia',
       'Av. Puerto 30', 39.470, -0.376, '06:00:00', '20:00:00',
       'LMMJV', 0, NULL, 'CISTERNA,CISTERNA_FOOD',
       NULL, 1, NULL
WHERE NOT EXISTS (SELECT 1 FROM tra_unloading_points WHERE point_code = 'VAL-DC');

-- =========================
-- Rutas
-- =========================
SET @route_bcn_sdr := (SELECT route_id FROM tra_routes WHERE route_code = 'BCN-SDR' LIMIT 1);
SET @route_bcn_sdr := IFNULL(@route_bcn_sdr, 'b6d34088-26d5-11f1-9b4a-5a0d05a37ed2');
INSERT INTO tra_routes (
  route_id, route_code, route_name, origin_loading_point_id, destination_unloading_point_id,
  standard_distance_km, standard_duration_minutes, countries_crossed,
  toll_cost_estimate, ferry_cost_estimate, co2_estimate_kg,
  preferred_mode, intermodal_possible, active, created_at, updated_at
)
SELECT @route_bcn_sdr, 'BCN-SDR', 'Barcelona > Santander', @lp_bcn, @up_sdr,
       690, 450, 'ES',
       85.00, NULL, 520.00,
       'road', 0, 1, NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM tra_routes WHERE route_code = 'BCN-SDR');

SET @route_bcn_mad := (SELECT route_id FROM tra_routes WHERE route_code = 'BCN-MAD' LIMIT 1);
SET @route_bcn_mad := IFNULL(@route_bcn_mad, 'b6d34196-26d5-11f1-9b4a-5a0d05a37ed2');
INSERT INTO tra_routes (
  route_id, route_code, route_name, origin_loading_point_id, destination_unloading_point_id,
  standard_distance_km, standard_duration_minutes, countries_crossed,
  toll_cost_estimate, ferry_cost_estimate, co2_estimate_kg,
  preferred_mode, intermodal_possible, active, created_at, updated_at
)
SELECT @route_bcn_mad, 'BCN-MAD', 'Barcelona > Madrid', @lp_bcn, @up_mad,
       620, 420, 'ES',
       60.00, NULL, 470.00,
       'road', 0, 1, NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM tra_routes WHERE route_code = 'BCN-MAD');

SET @route_val_mad := (SELECT route_id FROM tra_routes WHERE route_code = 'VAL-MAD' LIMIT 1);
SET @route_val_mad := IFNULL(@route_val_mad, 'b6d342a4-26d5-11f1-9b4a-5a0d05a37ed2');
INSERT INTO tra_routes (
  route_id, route_code, route_name, origin_loading_point_id, destination_unloading_point_id,
  standard_distance_km, standard_duration_minutes, countries_crossed,
  toll_cost_estimate, ferry_cost_estimate, co2_estimate_kg,
  preferred_mode, intermodal_possible, active, created_at, updated_at
)
SELECT @route_val_mad, 'VAL-MAD', 'Valencia > Madrid', @lp_val, @up_mad,
       355, 240, 'ES',
       25.00, NULL, 260.00,
       'road', 0, 1, NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM tra_routes WHERE route_code = 'VAL-MAD');

SET @route_lle_mor := (SELECT route_id FROM tra_routes WHERE route_code = 'LLE-MOR' LIMIT 1);
SET @route_lle_mor := IFNULL(@route_lle_mor, 'b6d343b2-26d5-11f1-9b4a-5a0d05a37ed2');
INSERT INTO tra_routes (
  route_id, route_code, route_name, origin_loading_point_id, destination_unloading_point_id,
  standard_distance_km, standard_duration_minutes, countries_crossed,
  toll_cost_estimate, ferry_cost_estimate, co2_estimate_kg,
  preferred_mode, intermodal_possible, active, created_at, updated_at
)
SELECT @route_lle_mor, 'LLE-MOR', 'Lleida > Morón de la Frontera', @lp_lle, @up_mor,
       980, 600, 'ES',
       95.00, NULL, 720.00,
       'road', 0, 1, NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM tra_routes WHERE route_code = 'LLE-MOR');

-- =========================
-- Asignaciones vehículo-ruta (preferencia suave)
-- =========================
INSERT INTO tra_vehicle_routes (vehicle_route_id, vehicle_id, route_id, active, notes, created_at, updated_at)
SELECT UUID(), @veh_004, @route_bcn_sdr, 1, 'Ruta habitual BCN-SDR', NOW(), NOW()
WHERE NOT EXISTS (
  SELECT 1 FROM tra_vehicle_routes WHERE vehicle_id = @veh_004 AND route_id = @route_bcn_sdr
);

INSERT INTO tra_vehicle_routes (vehicle_route_id, vehicle_id, route_id, active, notes, created_at, updated_at)
SELECT UUID(), @veh_005, @route_lle_mor, 1, 'Ruta habitual LLE-MOR', NOW(), NOW()
WHERE NOT EXISTS (
  SELECT 1 FROM tra_vehicle_routes WHERE vehicle_id = @veh_005 AND route_id = @route_lle_mor
);

INSERT INTO tra_vehicle_routes (vehicle_route_id, vehicle_id, route_id, active, notes, created_at, updated_at)
SELECT UUID(), @veh_006, @route_val_mad, 1, 'Ruta habitual VAL-MAD', NOW(), NOW()
WHERE NOT EXISTS (
  SELECT 1 FROM tra_vehicle_routes WHERE vehicle_id = @veh_006 AND route_id = @route_val_mad
);

-- =========================
-- Waypoints para ruta BCN-SDR
-- =========================
INSERT INTO tra_route_waypoints (
  route_waypoint_id, route_id, sequence_no, waypoint_name, city, latitude, longitude, notes, created_at, updated_at
)
SELECT UUID(), @route_bcn_sdr, 1, 'Barcelona', 'Barcelona', 41.354, 2.126, NULL, NOW(), NOW()
WHERE NOT EXISTS (
  SELECT 1 FROM tra_route_waypoints WHERE route_id = @route_bcn_sdr AND sequence_no = 1
);

INSERT INTO tra_route_waypoints (
  route_waypoint_id, route_id, sequence_no, waypoint_name, city, latitude, longitude, notes, created_at, updated_at
)
SELECT UUID(), @route_bcn_sdr, 2, 'Zaragoza', 'Zaragoza', 41.654, -0.877, NULL, NOW(), NOW()
WHERE NOT EXISTS (
  SELECT 1 FROM tra_route_waypoints WHERE route_id = @route_bcn_sdr AND sequence_no = 2
);

INSERT INTO tra_route_waypoints (
  route_waypoint_id, route_id, sequence_no, waypoint_name, city, latitude, longitude, notes, created_at, updated_at
)
SELECT UUID(), @route_bcn_sdr, 3, 'Pamplona', 'Pamplona', 42.816, -1.645, NULL, NOW(), NOW()
WHERE NOT EXISTS (
  SELECT 1 FROM tra_route_waypoints WHERE route_id = @route_bcn_sdr AND sequence_no = 3
);

INSERT INTO tra_route_waypoints (
  route_waypoint_id, route_id, sequence_no, waypoint_name, city, latitude, longitude, notes, created_at, updated_at
)
SELECT UUID(), @route_bcn_sdr, 4, 'Bilbao', 'Bilbao', 43.263, -2.935, NULL, NOW(), NOW()
WHERE NOT EXISTS (
  SELECT 1 FROM tra_route_waypoints WHERE route_id = @route_bcn_sdr AND sequence_no = 4
);

INSERT INTO tra_route_waypoints (
  route_waypoint_id, route_id, sequence_no, waypoint_name, city, latitude, longitude, notes, created_at, updated_at
)
SELECT UUID(), @route_bcn_sdr, 5, 'Santander', 'Santander', 43.462, -3.809, NULL, NOW(), NOW()
WHERE NOT EXISTS (
  SELECT 1 FROM tra_route_waypoints WHERE route_id = @route_bcn_sdr AND sequence_no = 5
);

COMMIT;
