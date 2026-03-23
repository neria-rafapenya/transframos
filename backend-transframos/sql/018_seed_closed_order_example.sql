-- Pedido cerrado de ejemplo asociado a un usuario concreto.
-- Usa NOT EXISTS para evitar duplicados.

START TRANSACTION;

SET @user_id := 'f3ef2eba-23b8-11f1-bf2e-5a0d05a37ed2';
SET @client_id := 'b6e1c000-26d5-11f1-9b4a-5a0d05a37ed2';
SET @quote_request_id := 'b6e10000-26d5-11f1-9b4a-5a0d05a37ed2';
SET @quote_option_id := 'b6e10010-26d5-11f1-9b4a-5a0d05a37ed2';
SET @draft_order_id := 'b6e10020-26d5-11f1-9b4a-5a0d05a37ed2';
SET @order_id := 'b6e1d000-26d5-11f1-9b4a-5a0d05a37ed2';
SET @order_number := 'ORD-EXAMPLE-001';

SET @product_id := (
  SELECT product_id FROM tra_products WHERE product_code = 'LECHE' LIMIT 1
);
SET @category_id := (
  SELECT category_id FROM tra_product_categories
  WHERE category_code IN ('FOOD_LIQ', 'FOOD')
  LIMIT 1
);
SET @origin_lp := (
  SELECT loading_point_id FROM tra_loading_points WHERE point_code = 'LLE-PLANT' LIMIT 1
);
SET @dest_up := (
  SELECT unloading_point_id FROM tra_unloading_points WHERE point_code = 'VAL-DC' LIMIT 1
);

INSERT INTO tra_clients (
  client_id,
  client_code,
  legal_name,
  trade_name,
  vat_number,
  country_code,
  status,
  client_type,
  primary_sector,
  sla_tier,
  payment_terms_days,
  preferred_language,
  notes,
  created_at,
  updated_at
)
SELECT
  @client_id,
  'CLI-EXAMPLE',
  'Cliente Demo Transframos',
  'Cliente Demo',
  'ESB12345678',
  'ES',
  'active',
  'fidelizado',
  'food',
  NULL,
  30,
  'es',
  'Cliente de prueba para pedidos cerrados.',
  NOW(),
  NOW()
WHERE NOT EXISTS (
  SELECT 1 FROM tra_clients WHERE client_id = @client_id
);

SET @column_exists := (
  SELECT COUNT(*)
  FROM information_schema.COLUMNS
  WHERE TABLE_SCHEMA = DATABASE()
    AND TABLE_NAME = 'tra_users'
    AND COLUMN_NAME = 'client_id'
);

SET @ddl := IF(
  @column_exists = 1,
  CONCAT('UPDATE tra_users SET client_id = ', QUOTE(@client_id), ' WHERE id = ', QUOTE(@user_id)),
  'SELECT 1'
);

PREPARE stmt FROM @ddl;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

INSERT INTO tra_ai_quote_requests (
  quote_request_id,
  conversation_session_id,
  external_reference,
  source_channel,
  client_id,
  requester_name,
  requester_email,
  requester_phone,
  requested_product_text,
  requested_product_id,
  requested_category_id,
  requested_volume_liters,
  requested_weight_tn,
  requested_load_date,
  origin_text,
  destination_text,
  origin_loading_point_id,
  destination_unloading_point_id,
  service_constraints_text,
  requested_mode,
  extracted_json,
  validation_status,
  created_at,
  updated_at,
  delivery_deadline_datetime,
  wizard_status,
  suggested_route_id,
  suggested_route_code,
  suggested_route_confidence,
  suggested_route_rationale,
  suggested_route_accepted
)
SELECT
  @quote_request_id,
  NULL,
  'CLOSED-EXAMPLE-001',
  'chat',
  @client_id,
  'Carlos Pérez',
  'carlos.perez@ejemplo.com',
  '+34 600 123 456',
  'Leche',
  @product_id,
  @category_id,
  15000,
  15.00,
  '2026-05-12',
  'Lleida 25004',
  'Valencia 46001',
  @origin_lp,
  @dest_up,
  'Entrega en horario de mañana. Prioridad alta.',
  'L',
  NULL,
  'passed',
  NOW(),
  NOW(),
  '2026-05-13 12:00:00',
  'completed',
  NULL,
  NULL,
  NULL,
  NULL,
  NULL
WHERE NOT EXISTS (
  SELECT 1 FROM tra_ai_quote_requests WHERE quote_request_id = @quote_request_id
);

INSERT INTO tra_ai_quote_options (
  quote_option_id,
  quote_request_id,
  vehicle_type_id,
  cleaning_protocol_id,
  estimated_cost,
  estimated_transit_hours,
  is_feasible,
  recommendation_score,
  reasoning_json,
  notes,
  created_at,
  updated_at
)
SELECT
  @quote_option_id,
  @quote_request_id,
  NULL,
  NULL,
  1350.00,
  7.50,
  1,
  0.86,
  JSON_OBJECT(
    'routeHint', 'Lleida - Valencia',
    'vehicle', 'Cisterna alimentaria',
    'confidence', 0.78
  ),
  'Opción cerrada y aceptada por el cliente.',
  NOW(),
  NOW()
WHERE NOT EXISTS (
  SELECT 1 FROM tra_ai_quote_options WHERE quote_option_id = @quote_option_id
);

INSERT INTO tra_ai_draft_orders (
  draft_order_id,
  quote_request_id,
  quote_option_id,
  status,
  notes,
  draft_payload_json,
  created_at,
  updated_at
)
SELECT
  @draft_order_id,
  @quote_request_id,
  @quote_option_id,
  'closed',
  'Pedido cerrado para pruebas de repetición.',
  JSON_OBJECT(
    'clientId', @client_id,
    'orderId', @order_id,
    'orderNumber', @order_number,
    'product', 'Leche',
    'volumeLiters', 15000,
    'origin', 'Lleida 25004',
    'destination', 'Valencia 46001',
    'pickupDate', '2026-05-12',
    'deliveryDeadline', '2026-05-13 12:00:00',
    'status', 'closed'
  ),
  NOW(),
  NOW()
WHERE NOT EXISTS (
  SELECT 1 FROM tra_ai_draft_orders WHERE draft_order_id = @draft_order_id
);

INSERT INTO tra_orders (
  order_id,
  order_number,
  client_id,
  quote_id,
  product_id,
  category_id,
  origin_loading_point_id,
  destination_unloading_point_id,
  requested_pickup_datetime,
  requested_delivery_datetime,
  confirmed_pickup_datetime,
  confirmed_delivery_datetime,
  ordered_volume_liters,
  ordered_weight_tn,
  service_mode,
  order_status,
  priority_level,
  client_reference,
  internal_notes,
  created_at,
  updated_at
)
SELECT
  @order_id,
  @order_number,
  @client_id,
  NULL,
  @product_id,
  @category_id,
  @origin_lp,
  @dest_up,
  '2026-05-12 12:00:00',
  '2026-05-13 12:00:00',
  '2026-05-12 12:00:00',
  '2026-05-13 12:00:00',
  15000,
  15.00,
  'road',
  'closed',
  'normal',
  'CLOSED-EXAMPLE-001',
  'Pedido cerrado de ejemplo generado por script.',
  NOW(),
  NOW()
WHERE NOT EXISTS (
  SELECT 1 FROM tra_orders WHERE order_id = @order_id
);

COMMIT;
