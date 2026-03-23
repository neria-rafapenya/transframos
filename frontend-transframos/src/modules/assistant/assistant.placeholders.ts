export const ASSISTANT_PLACEHOLDERS = [
  "Ej.: Necesito transportar 12000 litros de leche desde Malaga a Lleida",
  "Ej.: Transporte de 8000 L de aceite desde Sevilla a Zaragoza",
  "Ej.: Llevar 5000 litros de zumo de Valencia a Madrid",
  "Ej.: Necesito mover 20000 L de leche desde Lugo a Barcelona",
  "Ej.: Enviar 12000 litros de vino de La Rioja a Bilbao",
];

export const ASSISTANT_CORRECTION_PLACEHOLDERS = [
  "Escribe los datos que deseas corregir",
  "Indica que dato quieres corregir (origen, fecha, cantidad...)",
  "Corrige aqui los datos que no esten bien",
];

export const pickRandomPlaceholder = (items: string[]) => {
  if (!items.length) {
    return "";
  }
  const index = Math.floor(Math.random() * items.length);
  return items[index] ?? items[0];
};
