import { create } from "zustand";
import type { AssistantMessage, OrderDraft } from "./assistant.types";
import { createMessage } from "./assistant.mock";

type AssistantStore = {
  messages: AssistantMessage[];
  orderDraft: OrderDraft;
  initializeConversation: (messages: AssistantMessage[]) => void;
  addUserMessage: (content: string) => void;
  addAssistantMessage: (content: string) => void;
  setOrderDraft: (draft: OrderDraft) => void;
  resetConversation: () => void;
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

export const useAssistantStore = create<AssistantStore>((set) => ({
  messages: [],
  orderDraft: initialDraft,

  initializeConversation: (messages) => {
    set({
      messages,
      orderDraft: initialDraft,
    });
  },

  addUserMessage: (content) => {
    set((state) => ({
      messages: [...state.messages, createMessage("user", content)],
    }));
  },

  addAssistantMessage: (content) => {
    set((state) => ({
      messages: [...state.messages, createMessage("assistant", content)],
    }));
  },

  setOrderDraft: (draft) => {
    set({
      orderDraft: draft,
    });
  },

  resetConversation: () => {
    set({
      messages: [],
      orderDraft: initialDraft,
    });
  },
}));
