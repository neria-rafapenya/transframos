import type {
  ConversationResponse,
  SendMessagePayload,
  StartConversationPayload,
} from "./assistant.types";
import { useAuthStore } from "@/modules/auth/auth.store";

const API_BASE_URL =
  import.meta.env.VITE_API_URL?.replace(/\/$/, "") ?? "http://localhost:3000";

const buildUrl = (path: string) => `${API_BASE_URL}${path}`;

const defaultHeaders: HeadersInit = {
  "Content-Type": "application/json",
};

const parseErrorMessage = async (response: Response) => {
  try {
    const data = await response.json();

    if (typeof data?.message === "string") {
      return data.message;
    }

    if (Array.isArray(data?.message)) {
      return data.message.join(", ");
    }

    return "Se ha producido un error inesperado.";
  } catch {
    return "Se ha producido un error inesperado.";
  }
};

const handleUnauthorized = () => {
  useAuthStore.getState().clearSession();
  if (typeof window !== "undefined") {
    window.location.assign("/login");
  }
};

const request = async <T>(path: string, init?: RequestInit): Promise<T> => {
  const response = await fetch(buildUrl(path), {
    credentials: "include",
    headers: defaultHeaders,
    ...init,
  });

  if (!response.ok) {
    if (response.status === 401) {
      handleUnauthorized();
    }
    const message = await parseErrorMessage(response);
    throw new Error(message);
  }

  return response.json() as Promise<T>;
};

export const assistantApi = {
  startConversation: async (
    payload: StartConversationPayload,
  ): Promise<ConversationResponse> => {
    return request<ConversationResponse>("/conversations/start", {
      method: "POST",
      body: JSON.stringify(payload),
    });
  },

  sendMessage: async (
    sessionId: number,
    payload: SendMessagePayload,
  ): Promise<ConversationResponse> => {
    return request<ConversationResponse>(
      `/conversations/${sessionId}/message`,
      {
        method: "POST",
        body: JSON.stringify(payload),
      },
    );
  },

  getConversation: async (sessionId: number): Promise<ConversationResponse> => {
    return request<ConversationResponse>(`/conversations/${sessionId}`, {
      method: "GET",
    });
  },
};
