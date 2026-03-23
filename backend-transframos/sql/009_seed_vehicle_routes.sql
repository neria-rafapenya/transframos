-- Seed de asignaciones vehículo-ruta evitando rutas repetidas entre vehículos.
-- Usa route_code para poder convivir con distintos dumps/entornos.

INSERT INTO tra_vehicle_routes (vehicle_route_id, vehicle_id, route_id, active, notes)
SELECT UUID(), v.vehicle_id, r.route_id, 1, 'Asignación inicial MAL-MAD'
FROM tra_vehicles v
JOIN tra_routes r ON r.route_code = 'MAL-MAD'
WHERE v.vehicle_id = '3737307a-249d-11f1-9638-5a0d05a37ed3'
  AND NOT EXISTS (
    SELECT 1 FROM tra_vehicle_routes vr
    WHERE vr.vehicle_id = v.vehicle_id AND vr.route_id = r.route_id
  )
  AND NOT EXISTS (
    SELECT 1 FROM tra_vehicle_routes vr
    WHERE vr.route_id = r.route_id
  );

INSERT INTO tra_vehicle_routes (vehicle_route_id, vehicle_id, route_id, active, notes)
SELECT UUID(), v.vehicle_id, r.route_id, 1, 'Asignación inicial BCN-SDR'
FROM tra_vehicles v
JOIN tra_routes r ON r.route_code = 'BCN-SDR'
WHERE v.vehicle_id = '373734b2-249d-11f1-9638-5a0d05a37ed3'
  AND NOT EXISTS (
    SELECT 1 FROM tra_vehicle_routes vr
    WHERE vr.vehicle_id = v.vehicle_id AND vr.route_id = r.route_id
  )
  AND NOT EXISTS (
    SELECT 1 FROM tra_vehicle_routes vr
    WHERE vr.route_id = r.route_id
  );

INSERT INTO tra_vehicle_routes (vehicle_route_id, vehicle_id, route_id, active, notes)
SELECT UUID(), v.vehicle_id, r.route_id, 1, 'Asignación inicial LLE-MOR'
FROM tra_vehicles v
JOIN tra_routes r ON r.route_code = 'LLE-MOR'
WHERE v.vehicle_id = '3737355c-249d-11f1-9638-5a0d05a37ed3'
  AND NOT EXISTS (
    SELECT 1 FROM tra_vehicle_routes vr
    WHERE vr.vehicle_id = v.vehicle_id AND vr.route_id = r.route_id
  )
  AND NOT EXISTS (
    SELECT 1 FROM tra_vehicle_routes vr
    WHERE vr.route_id = r.route_id
  );
