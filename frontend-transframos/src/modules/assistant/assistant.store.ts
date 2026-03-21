import { create } from "zustand";
import { assistantApi } from "./assistant.api";
import type {
  AssistantMessage,
  BackendQuoteOption,
  BackendQuoteRequest,
  BackendValidationSummary,
  BackendWizardStep,
  ConversationResponse,
  OrderDraft,
  StartConversationPayload,
} from "./assistant.types";

type AssistantStore = {
  sessionId: number | null;
  messages: AssistantMessage[];
  wizard: BackendWizardStep[];
  currentStep: BackendWizardStep | null;
  quoteRequest: BackendQuoteRequest | null;
  topOption: BackendQuoteOption | null;
  validationSummary: BackendValidationSummary | null;
  orderDraft: OrderDraft;
  isLoading: boolean;
  error: string | null;
  startConversation: (payload?: StartConversationPayload) => Promise<void>;
  sendMessage: (content: string) => Promise<void>;
  refreshConversation: () => Promise<void>;
  resetConversation: () => void;
  clearError: () => void;
};

const initialDraft: OrderDraft = {
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
};

const mapCurrentStepToMissingData = (
  wizard: BackendWizardStep[],
  currentStep: BackendWizardStep | null,
): string[] => {
  const pendingFromWizard = wizard
    .filter((step) => step.status !== "completed" && step.status !== "skipped")
    .map((step) => step.wizardStep?.label ?? step.stepCode);

  if (pendingFromWizard.length > 0) {
    return pendingFromWizard;
  }

  if (currentStep?.wizardStep?.label) {
    return [currentStep.wizardStep.label];
  }

  return [];
};

const buildOrderDraftFromResponse = (
  response: ConversationResponse,
): OrderDraft => {
  const { quoteRequest, topOption, wizard, currentStep } = response;
  const selectedVehicleCode = getReasoningText(
    topOption?.reasoningJson,
    "selectedVehicleCode",
  );

  return {
    product:
      getWizardRawText(wizard, "product") ??
      toNullableText(quoteRequest?.productId),
    volume: quoteRequest?.quantityValue ?? null,
    unit: quoteRequest?.quantityUnit ?? null,
    origin:
      getWizardRawText(wizard, "origin") ??
      toNullableText(quoteRequest?.originLocationId),
    destination:
      getWizardRawText(wizard, "destination") ??
      toNullableText(quoteRequest?.destinationLocationId),
    requestedDate: quoteRequest?.requestedPickupAt ?? null,
    deliveryDeadline: quoteRequest?.deliveryDeadlineAt ?? null,
    status: mapDraftStatus(response),
    proposedOption: topOption
      ? {
          vehicle:
            selectedVehicleCode ??
            (topOption.vehicleTypeId !== null
              ? `Vehículo #${topOption.vehicleTypeId}`
              : "Pendiente"),
          departure: quoteRequest?.requestedPickupAt ?? "Pendiente",
          arrival: quoteRequest?.deliveryDeadlineAt ?? "Pendiente",
          note:
            topOption.notes ??
            "Opción generada automáticamente por el motor de pricing.",
          estimatedCost: topOption.estimatedCost ?? null,
          estimatedTransitHours: topOption.estimatedTransitHours ?? null,
        }
      : null,
    missingClientData: mapCurrentStepToMissingData(wizard, currentStep),
  };
};

const getWizardRawText = (
  wizard: BackendWizardStep[],
  stepCode: string,
): string | null => {
  const step = wizard.find((item) => item.stepCode === stepCode);
  const rawText = step?.valueJson?.rawText;

  return typeof rawText === "string" ? rawText : null;
};

const getReasoningText = (
  reasoningJson: Record<string, unknown> | null | undefined,
  key: string,
): string | null => {
  if (!reasoningJson) {
    return null;
  }

  const value = reasoningJson[key];
  if (typeof value !== "string") {
    return null;
  }

  const trimmed = value.trim();
  return trimmed.length > 0 ? `Vehículo ${trimmed}` : null;
};

const toNullableText = (
  value: string | number | null | undefined,
): string | null => {
  if (value === null || typeof value === "undefined") {
    return null;
  }

  return String(value);
};

const mapDraftStatus = (
  response: ConversationResponse,
): OrderDraft["status"] => {
  if (
    response.validationSummary?.failed &&
    response.validationSummary.failed > 0
  ) {
    return "blocked";
  }

  if (response.topOption) {
    return "ready";
  }

  if (response.quoteRequest?.wizardStatus === "validating") {
    return "validating";
  }

  if (response.quoteRequest?.wizardStatus === "collecting_data") {
    return "collecting";
  }

  if (response.quoteRequest?.wizardStatus === "awaiting_confirmation") {
    return "alternative_proposed";
  }

  return "idle";
};

const applyConversationResponse = (
  response: ConversationResponse,
): Pick<
  AssistantStore,
  | "sessionId"
  | "messages"
  | "wizard"
  | "currentStep"
  | "quoteRequest"
  | "topOption"
  | "validationSummary"
  | "orderDraft"
  | "error"
> => ({
  sessionId: response.session.id,
  messages: response.messages.map((message) => ({
    id: String(message.id),
    role: message.role === "assistant" ? "assistant" : "user",
    content: message.content,
    createdAt: message.createdAt,
  })),
  wizard: response.wizard,
  currentStep: response.currentStep,
  quoteRequest: response.quoteRequest,
  topOption: response.topOption,
  validationSummary: response.validationSummary,
  orderDraft: buildOrderDraftFromResponse(response),
  error: null,
});

export const useAssistantStore = create<AssistantStore>((set, get) => ({
  sessionId: null,
  messages: [],
  wizard: [],
  currentStep: null,
  quoteRequest: null,
  topOption: null,
  validationSummary: null,
  orderDraft: initialDraft,
  isLoading: false,
  error: null,

  startConversation: async (payload) => {
    set({
      isLoading: true,
      error: null,
    });

    try {
      const response = await assistantApi.startConversation(payload ?? {});

      set({
        ...applyConversationResponse(response),
        isLoading: false,
      });
    } catch (error) {
      set({
        isLoading: false,
        error:
          error instanceof Error
            ? error.message
            : "No se ha podido iniciar la conversación",
      });
    }
  },

  sendMessage: async (content) => {
    const sessionId = get().sessionId;

    if (!sessionId) {
      set({
        error: "No existe una sesión de conversación activa",
      });
      return;
    }

    set({
      isLoading: true,
      error: null,
    });

    try {
      const response = await assistantApi.sendMessage(sessionId, {
        message: content,
      });

      set({
        ...applyConversationResponse(response),
        isLoading: false,
      });
    } catch (error) {
      set({
        isLoading: false,
        error:
          error instanceof Error
            ? error.message
            : "No se ha podido enviar el mensaje",
      });
    }
  },

  refreshConversation: async () => {
    const sessionId = get().sessionId;

    if (!sessionId) {
      return;
    }

    set({
      isLoading: true,
      error: null,
    });

    try {
      const response = await assistantApi.getConversation(sessionId);

      set({
        ...applyConversationResponse(response),
        isLoading: false,
      });
    } catch (error) {
      set({
        isLoading: false,
        error:
          error instanceof Error
            ? error.message
            : "No se ha podido refrescar la conversación",
      });
    }
  },

  resetConversation: () => {
    set({
      sessionId: null,
      messages: [],
      wizard: [],
      currentStep: null,
      quoteRequest: null,
      topOption: null,
      validationSummary: null,
      orderDraft: initialDraft,
      isLoading: false,
      error: null,
    });
  },

  clearError: () => {
    set({ error: null });
  },
}));
