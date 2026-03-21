import type { AuthUser } from "@/modules/auth/auth.types";

export type AssistantRole = "assistant" | "user";

export type AssistantMessage = {
  id: string;
  role: AssistantRole;
  content: string;
  createdAt: string;
};

export type ProposedOption = {
  vehicle: string;
  departure: string;
  arrival: string;
  note: string;
  estimatedCost?: number | null;
  estimatedTransitHours?: number | null;
};

export type OrderDraftStatus =
  | "idle"
  | "collecting"
  | "validating"
  | "alternative_proposed"
  | "ready"
  | "blocked";

export type OrderDraft = {
  product: string | null;
  volume: number | null;
  unit: string | null;
  origin: string | null;
  destination: string | null;
  requestedDate: string | null;
  deliveryDeadline: string | null;
  status: OrderDraftStatus;
  proposedOption: ProposedOption | null;
  missingClientData: string[];
};

export type AssistantReplyContext = {
  userMessage: string;
  currentDraft: OrderDraft;
  user: AuthUser;
};

export type AssistantReplyResult = {
  message: string;
  nextDraft: OrderDraft;
};

export type BackendConversationMessage = {
  id: number;
  role: string;
  content: string;
  createdAt: string;
};

export type BackendWizardStep = {
  id: number;
  sessionId: number;
  stepCode: string;
  status: string;
  valueJson: Record<string, unknown> | null;
  notes: string | null;
  completedAt: string | null;
  createdAt: string;
  updatedAt: string;
  wizardStep?: {
    id: number;
    code: string;
    label: string;
    stepOrder: number;
    dataKey: string;
    isRequired: boolean;
    helpText: string | null;
    completionRule: string | null;
    validationEndpoint: string | null;
    isActive: boolean;
  };
};

export type BackendQuoteRequest = {
  id: number;
  conversationSessionId: number | null;
  productId: number | null;
  quantityValue: number | null;
  quantityUnit: string | null;
  originLocationId: number | null;
  destinationLocationId: number | null;
  requestedPickupAt: string | null;
  deliveryDeadlineAt: string | null;
  wizardStatus: string;
  validationStatus: string;
  quoteStatus: string;
  notes: string | null;
  rawRequestJson: Record<string, unknown> | null;
  createdAt: string;
  updatedAt: string;
};

export type BackendQuoteOption = {
  id: number;
  quoteRequestId: number;
  vehicleTypeId: number | null;
  cleaningProtocolId: number | null;
  estimatedCost: number | null;
  estimatedTransitHours: number | null;
  isFeasible: boolean;
  recommendationScore: number | null;
  reasoningJson: Record<string, unknown> | null;
  notes: string | null;
  createdAt: string;
  updatedAt: string;
};

export type BackendConversationSession = {
  id: number;
  userId: number;
  title: string | null;
  status: string;
  channel: string;
  language: string;
  contextJson: Record<string, unknown> | null;
  createdAt: string;
  updatedAt: string;
};

export type BackendValidationSummary = {
  quoteRequestId: number;
  total: number;
  passed: number;
  failed: number;
  warnings: number;
  results: Array<{
    id?: number;
    quoteRequestId?: number;
    ruleCode: string;
    severity: string;
    passed: boolean;
    message: string | null;
    payloadJson?: Record<string, unknown> | null;
    createdAt?: string;
  }>;
};

export type ConversationResponse = {
  session: BackendConversationSession;
  messages: BackendConversationMessage[];
  assistantMessage: string | null;
  wizard: BackendWizardStep[];
  currentStep: BackendWizardStep | null;
  quoteRequest: BackendQuoteRequest | null;
  topOption: BackendQuoteOption | null;
  validationSummary: BackendValidationSummary | null;
};

export type StartConversationPayload = {
  title?: string;
  channel?: string;
  language?: string;
  initialMessage?: string;
  contextJson?: Record<string, unknown>;
};

export type SendMessagePayload = {
  message: string;
};
