-- Crea puntos y ruta estándar Lleida -> Morón de la Frontera.

SET @origin_id := (
  SELECT loading_point_id
  FROM tra_loading_points
  WHERE point_code = 'LLE-PLANTA'
  LIMIT 1
);
SET @origin_id := IFNULL(@origin_id, UUID());

INSERT INTO tra_loading_points (
  loading_point_id,
  client_id,
  point_code,
  point_name,
  country_code,
  postal_code,
  city,
  address_line1,
  latitude,
  longitude,
  loading_window_start,
  loading_window_end,
  loading_days_mask,
  requires_prealert,
  access_restrictions,
  allowed_vehicle_types,
  default_contact_id,
  active,
  notes
)
SELECT
  @origin_id,
  NULL,
  'LLE-PLANTA',
  'Planta Lleida',
  'ES',
  '25001',
  'Lleida',
  'Lleida',
  41.6176,
  0.6200,
  NULL,
  NULL,
  NULL,
  0,
  NULL,
  'CISTERNA, CISTERNA_FOOD',
  NULL,
  1,
  NULL
WHERE NOT EXISTS (
  SELECT 1 FROM tra_loading_points WHERE point_code = 'LLE-PLANTA'
);

SET @destination_id := (
  SELECT unloading_point_id
  FROM tra_unloading_points
  WHERE point_code = 'MOR-PLANTA'
  LIMIT 1
);
SET @destination_id := IFNULL(@destination_id, UUID());

INSERT INTO tra_unloading_points (
  unloading_point_id,
  client_id,
  point_code,
  point_name,
  country_code,
  postal_code,
  city,
  address_line1,
  latitude,
  longitude,
  unloading_window_start,
  unloading_window_end,
  unloading_days_mask,
  requires_prealert,
  discharge_requirements,
  allowed_vehicle_types,
  default_contact_id,
  active,
  notes
)
SELECT
  @destination_id,
  NULL,
  'MOR-PLANTA',
  'Planta Morón de la Frontera',
  'ES',
  '41530',
  'Morón de la Frontera',
  'Morón de la Frontera',
  37.1200,
  -5.4510,
  NULL,
  NULL,
  NULL,
  0,
  NULL,
  'CISTERNA, CISTERNA_FOOD',
  NULL,
  1,
  NULL
WHERE NOT EXISTS (
  SELECT 1 FROM tra_unloading_points WHERE point_code = 'MOR-PLANTA'
);

INSERT INTO tra_routes (
  route_id,
  route_code,
  route_name,
  origin_loading_point_id,
  destination_unloading_point_id,
  standard_distance_km,
  standard_duration_minutes,
  countries_crossed,
  toll_cost_estimate,
  ferry_cost_estimate,
  co2_estimate_kg,
  preferred_mode,
  intermodal_possible,
  active
)
SELECT
  UUID(),
  'LLE-MOR',
  'Lleida > Morón de la Frontera',
  @origin_id,
  @destination_id,
  980,
  600,
  'ES',
  NULL,
  NULL,
  NULL,
  'road',
  0,
  1
WHERE NOT EXISTS (
  SELECT 1 FROM tra_routes WHERE route_code = 'LLE-MOR'
);

UPDATE tra_routes
SET standard_distance_km = 980,
    standard_duration_minutes = 600
WHERE route_code = 'LLE-MOR';
