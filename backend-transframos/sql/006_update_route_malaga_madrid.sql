-- Ajuste de distancia y duración para la ruta Málaga -> Madrid.
-- Ejecutar después de crear la ruta con route_code = 'MAL-MAD'.

UPDATE tra_routes
SET standard_distance_km = 530,
    standard_duration_minutes = 360
WHERE route_code = 'MAL-MAD';
