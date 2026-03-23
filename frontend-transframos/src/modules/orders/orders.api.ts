import { useAuthStore } from "@/modules/auth/auth.store";

export type OrderSummary = {
  id: string;
  orderNumber: string;
  orderStatus: string;
  requestedPickupDatetime: string | null;
  requestedDeliveryDatetime: string | null;
  createdAt: string;
};

export type OrderDetail = OrderSummary & {
  quoteId: string | null;
  productId: string;
  categoryId: string;
  originLoadingPointId: string;
  destinationUnloadingPointId: string;
  confirmedPickupDatetime: string | null;
  confirmedDeliveryDatetime: string | null;
  orderedVolumeLiters: number;
  orderedWeightTn: number | null;
  serviceMode: string;
  priorityLevel: string | null;
  clientReference: string | null;
  internalNotes: string | null;
  updatedAt: string;
};

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

const request = async <T>(path: string): Promise<T> => {
  const response = await fetch(buildUrl(path), {
    credentials: "include",
    headers: defaultHeaders,
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

export const ordersApi = {
  getOrders: async (limit = 50): Promise<OrderSummary[]> =>
    request<OrderSummary[]>(`/orders?limit=${limit}`),
  getOrderById: async (id: string): Promise<OrderDetail> =>
    request<OrderDetail>(`/orders/${id}`),
};
