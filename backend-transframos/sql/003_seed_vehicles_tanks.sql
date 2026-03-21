-- Seed basico de vehiculos y tanques para pruebas.
-- Ejecuta este script en provider_manager antes de crear relaciones en tra_vehicle_tanks.

INSERT INTO tra_vehicles (
  vehicle_id,
  vehicle_code,
  plate_number,
  vehicle_type,
  gps_enabled,
  intermodal_capable,
  maintenance_status,
  active
) VALUES
  (UUID(), 'VEH-001', '1234-ABC', 'CISTERNA', 1, 0, 'ok', 1),
  (UUID(), 'VEH-002', '5678-DEF', 'CISTERNA', 1, 1, 'ok', 1),
  (UUID(), 'VEH-003', '9012-GHI', 'CISTERNA_FOOD', 1, 0, 'ok', 1);

INSERT INTO tra_tanks (
  tank_id,
  tank_code,
  tank_type,
  capacity_liters,
  max_payload_tn,
  temperature_control,
  heating_system,
  cooling_system,
  self_unloading,
  bacteriological_filter,
  compartment_count,
  cleaning_status,
  ownership_type,
  active,
  dedicated_use,
  notes
) VALUES
  (UUID(), 'TNK-001', 'food_grade', 26000, 24.00, 1, 0, 1, 1, 1, 3, 'clean', 'owned', 1, 'milk', 'Tanque dedicado a leche.'),
  (UUID(), 'TNK-002', 'standard', 24000, 22.50, 0, 0, 0, 1, 0, 2, 'clean', 'owned', 1, NULL, NULL),
  (UUID(), 'TNK-003', 'food_grade', 28000, 25.00, 1, 1, 1, 1, 1, 4, 'clean', 'leased', 1, 'milk', 'Tanque con control termico.');

-- Recupera los IDs recien creados para usarlos en tra_vehicle_tanks.
SELECT vehicle_id, vehicle_code, vehicle_type FROM tra_vehicles
WHERE vehicle_code IN ('VEH-001', 'VEH-002', 'VEH-003');

SELECT tank_id, tank_code, tank_type FROM tra_tanks
WHERE tank_code IN ('TNK-001', 'TNK-002', 'TNK-003');
