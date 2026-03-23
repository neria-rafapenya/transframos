-- Ajusta los pasos de origen/destino para solicitar solo ciudad y código postal en presupuesto.
-- Las direcciones exactas quedan como no obligatorias hasta la tramitación.

UPDATE tra_ai_wizard_steps
SET step_label = 'Ciudad y código postal de origen'
WHERE step_code = 'origin';

UPDATE tra_ai_wizard_steps
SET step_label = 'Ciudad y código postal de destino'
WHERE step_code = 'destination';

UPDATE tra_ai_wizard_steps
SET is_required = 0
WHERE step_code IN (
  'origin_address',
  'destination_address',
  'origin_contact_name',
  'origin_contact_phone',
  'destination_contact_name',
  'destination_contact_phone'
);
