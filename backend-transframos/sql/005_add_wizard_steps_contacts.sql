-- Añade pasos de dirección y contacto para origen/destino.
-- Reordena fechas para dejar los contactos antes de la fecha de recogida.

UPDATE tra_ai_wizard_steps
SET step_order = 11
WHERE step_code = 'requested_date';

UPDATE tra_ai_wizard_steps
SET step_order = 12
WHERE step_code = 'delivery_deadline';

INSERT INTO tra_ai_wizard_steps (
  wizard_step_id,
  step_code,
  step_label,
  step_order,
  maps_to_table,
  maps_to_field,
  is_required,
  allow_free_text,
  active
)
SELECT UUID(), 'origin_address', 'Dirección de recogida', 5, NULL, NULL, 1, 1, 1
WHERE NOT EXISTS (
  SELECT 1 FROM tra_ai_wizard_steps WHERE step_code = 'origin_address'
);

INSERT INTO tra_ai_wizard_steps (
  wizard_step_id,
  step_code,
  step_label,
  step_order,
  maps_to_table,
  maps_to_field,
  is_required,
  allow_free_text,
  active
)
SELECT UUID(), 'origin_contact_name', 'Responsable de recogida', 6, NULL, NULL, 1, 1, 1
WHERE NOT EXISTS (
  SELECT 1 FROM tra_ai_wizard_steps WHERE step_code = 'origin_contact_name'
);

INSERT INTO tra_ai_wizard_steps (
  wizard_step_id,
  step_code,
  step_label,
  step_order,
  maps_to_table,
  maps_to_field,
  is_required,
  allow_free_text,
  active
)
SELECT UUID(), 'origin_contact_phone', 'Teléfono de recogida', 7, NULL, NULL, 1, 1, 1
WHERE NOT EXISTS (
  SELECT 1 FROM tra_ai_wizard_steps WHERE step_code = 'origin_contact_phone'
);

INSERT INTO tra_ai_wizard_steps (
  wizard_step_id,
  step_code,
  step_label,
  step_order,
  maps_to_table,
  maps_to_field,
  is_required,
  allow_free_text,
  active
)
SELECT UUID(), 'destination_address', 'Dirección de entrega', 8, NULL, NULL, 1, 1, 1
WHERE NOT EXISTS (
  SELECT 1 FROM tra_ai_wizard_steps WHERE step_code = 'destination_address'
);

INSERT INTO tra_ai_wizard_steps (
  wizard_step_id,
  step_code,
  step_label,
  step_order,
  maps_to_table,
  maps_to_field,
  is_required,
  allow_free_text,
  active
)
SELECT UUID(), 'destination_contact_name', 'Responsable de entrega', 9, NULL, NULL, 1, 1, 1
WHERE NOT EXISTS (
  SELECT 1 FROM tra_ai_wizard_steps WHERE step_code = 'destination_contact_name'
);

INSERT INTO tra_ai_wizard_steps (
  wizard_step_id,
  step_code,
  step_label,
  step_order,
  maps_to_table,
  maps_to_field,
  is_required,
  allow_free_text,
  active
)
SELECT UUID(), 'destination_contact_phone', 'Teléfono de entrega', 10, NULL, NULL, 1, 1, 1
WHERE NOT EXISTS (
  SELECT 1 FROM tra_ai_wizard_steps WHERE step_code = 'destination_contact_phone'
);
