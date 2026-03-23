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

export type SandboxSnapshot = {
  products: Record<string, unknown>[];
  productCategories: Record<string, unknown>[];
  vehicles: Record<string, unknown>[];
  vehicleAvailability: Record<string, unknown>[];
  tanks: Record<string, unknown>[];
  tankAuthorizations: Record<string, unknown>[];
  vehicleTanks: Record<string, unknown>[];
  routes: Record<string, unknown>[];
  vehicleRoutes: Record<string, unknown>[];
  routeWaypoints: Record<string, unknown>[];
  loadingPoints: Record<string, unknown>[];
  unloadingPoints: Record<string, unknown>[];
  compatibilityRules: Record<string, unknown>[];
};

export const settingsApi = {
  getSandboxSnapshot: async (): Promise<SandboxSnapshot> =>
    request<SandboxSnapshot>("/catalog/admin/sandbox"),
};
