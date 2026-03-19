import dayjs from "dayjs";
import type {
  AssistantMessage,
  AssistantReplyContext,
  AssistantReplyResult,
  OrderDraft,
} from "./assistant.types";

const createMessage = (
  role: "assistant" | "user",
  content: string,
): AssistantMessage => ({
  id: crypto.randomUUID(),
  role,
  content,
  createdAt: dayjs().toISOString(),
});

export const getInitialAssistantMessages = (
  fullName: string,
): AssistantMessage[] => [
  createMessage(
    "assistant",
    `Hola, ${fullName}. ¿Qué servicio necesitas hoy? Puedes escribirme algo como “Necesito transportar 1400 litros de zumo”.`,
  ),
];

const baseDraft = (): OrderDraft => ({
  product: null,
  volume: null,
  unit: null,
  origin: null,
  destination: null,
  requestedDate: null,
  deliveryDeadline: null,
  status: "idle",
  proposedOption: null,
  missingClientData: [],
});

const extractVolumeAndProduct = (text: string) => {
  const volumeMatch = text.match(/(\d{2,5})\s*(litros|l|kg|toneladas|tn)?/i);
  const volume = volumeMatch ? Number(volumeMatch[1]) : null;
  const unit = volumeMatch?.[2] ?? "litros";

  let product: string | null = null;

  if (/zumo/i.test(text)) product = "Zumo";
  if (/aceite/i.test(text)) product = "Aceite vegetal";
  if (/leche/i.test(text)) product = "Leche";
  if (/vino/i.test(text)) product = "Vino";

  return { volume, unit, product };
};

const extractRoute = (text: string) => {
  const routeMatch =
    text.match(/desde\s+([a-záéíóúüñ\s]+)\s+a\s+([a-záéíóúüñ\s]+)/i) ??
    text.match(/de\s+([a-záéíóúüñ\s]+)\s+a\s+([a-záéíóúüñ\s]+)/i);

  return {
    origin: routeMatch?.[1]?.trim() ?? null,
    destination: routeMatch?.[2]?.trim() ?? null,
  };
};

const extractDateAndDeadline = (text: string) => {
  const normalized = text.toLowerCase();

  let requestedDate: string | null = null;
  let deliveryDeadline: string | null = null;

  if (normalized.includes("jueves 21")) {
    requestedDate = "Jueves 21";
  } else if (normalized.includes("jueves")) {
    requestedDate = "Jueves";
  } else if (normalized.includes("viernes")) {
    requestedDate = "Viernes";
  } else if (normalized.includes("mañana")) {
    requestedDate = "Mañana";
  }

  const beforeHourMatch = text.match(/antes de las?\s+(\d{1,2}[:.]?\d{0,2})/i);
  if (beforeHourMatch) {
    deliveryDeadline = `Antes de las ${beforeHourMatch[1].replace(".", ":")}`;
  }

  return { requestedDate, deliveryDeadline };
};

export const buildAssistantReply = ({
  userMessage,
  currentDraft,
  user,
}: AssistantReplyContext): AssistantReplyResult => {
  const message = userMessage.trim();
  const lower = message.toLowerCase();

  if (/reiniciar|empezar de nuevo|nuevo pedido/i.test(lower)) {
    return {
      message: `Perfecto, ${user.fullName}. Empezamos de nuevo. ¿Qué producto necesitas transportar y en qué cantidad?`,
      nextDraft: {
        ...baseDraft(),
        status: "collecting",
      },
    };
  }

  if (
    /sí|si,|me interesa|adelante|acepto|confirmo/i.test(lower) &&
    currentDraft.proposedOption
  ) {
    const missingClientData: string[] = [];

    if (!user.defaultLoadingPoint) missingClientData.push("punto de carga");
    if (!user.defaultUnloadingPoint)
      missingClientData.push("punto de descarga");
    if (!user.phone) missingClientData.push("teléfono de contacto");

    const confirmationText =
      missingClientData.length === 0
        ? `Perfecto. Ya tengo tus datos de empresa y contacto habitual. Puedo dejar preparado el borrador del pedido con salida ${currentDraft.proposedOption.departure} y llegada estimada ${currentDraft.proposedOption.arrival}.`
        : `Perfecto. Puedo avanzar con la propuesta, pero aún necesito estos datos: ${missingClientData.join(
            ", ",
          )}.`;

    return {
      message: confirmationText,
      nextDraft: {
        ...currentDraft,
        status: "ready",
        missingClientData,
      },
    };
  }

  if (
    /no|no me sirve|otra fecha|buscar otra/i.test(lower) &&
    currentDraft.proposedOption
  ) {
    return {
      message:
        "De acuerdo. Mantengo producto, cantidad y trayecto. Indícame otra fecha o una franja distinta y vuelvo a comprobar disponibilidad.",
      nextDraft: {
        ...currentDraft,
        status: "collecting",
        proposedOption: null,
      },
    };
  }

  const extractedProduct = extractVolumeAndProduct(message);
  const extractedRoute = extractRoute(message);
  const extractedDate = extractDateAndDeadline(message);

  const nextDraft: OrderDraft = {
    ...currentDraft,
    product: currentDraft.product ?? extractedProduct.product,
    volume: currentDraft.volume ?? extractedProduct.volume,
    unit: currentDraft.unit ?? extractedProduct.unit,
    origin: currentDraft.origin ?? extractedRoute.origin,
    destination: currentDraft.destination ?? extractedRoute.destination,
    requestedDate: currentDraft.requestedDate ?? extractedDate.requestedDate,
    deliveryDeadline:
      currentDraft.deliveryDeadline ?? extractedDate.deliveryDeadline,
    status: "collecting",
    proposedOption: currentDraft.proposedOption,
  };

  if (!nextDraft.product || !nextDraft.volume) {
    return {
      message:
        "Entendido. Para empezar, dime qué producto necesitas transportar y qué cantidad aproximada.",
      nextDraft,
    };
  }

  if (!nextDraft.origin || !nextDraft.destination) {
    return {
      message:
        "Perfecto. ¿Desde qué punto de salida debe cargarse y a qué destino debe entregarse?",
      nextDraft,
    };
  }

  if (!nextDraft.requestedDate || !nextDraft.deliveryDeadline) {
    return {
      message:
        "Gracias. Ahora necesito la fecha solicitada y la hora límite de entrega, por ejemplo: jueves 21 antes de las 22:00.",
      nextDraft,
    };
  }

  return {
    message:
      "He comprobado la disponibilidad simulada. Para esa fecha no hay vehículos compatibles disponibles con llegada antes del límite solicitado. Sí puedo ofrecerte una alternativa: vehículo Scania Modelo TARA, salida el día 20 a las 21:45 y llegada estimada el día 21 a las 03:00. ¿Te interesa esta opción o prefieres probar otra fecha?",
    nextDraft: {
      ...nextDraft,
      status: "alternative_proposed",
      proposedOption: {
        vehicle: "Scania Modelo TARA",
        departure: "20 a las 21:45",
        arrival: "21 a las 03:00",
        note: "Alternativa disponible simulada por la demo",
      },
    },
  };
};

export { createMessage };
