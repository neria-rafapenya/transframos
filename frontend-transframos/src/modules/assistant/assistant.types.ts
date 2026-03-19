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
};

export type OrderDraft = {
  product: string | null;
  volume: number | null;
  unit: string | null;
  origin: string | null;
  destination: string | null;
  requestedDate: string | null;
  deliveryDeadline: string | null;
  status: "idle" | "collecting" | "alternative_proposed" | "ready";
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
