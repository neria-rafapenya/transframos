import type {
  AuthResponseDto,
  AuthUser,
  LoginRequestDto,
  RegisterRequestDto,
} from "./auth.types";

const API_URL = import.meta.env.VITE_API_URL || "http://localhost:3000/api";

type RequestOptions = {
  method?: "GET" | "POST" | "PATCH" | "DELETE";
  body?: unknown;
};

async function request<T>(
  path: string,
  options: RequestOptions = {},
): Promise<T> {
  const response = await fetch(`${API_URL}${path}`, {
    method: options.method ?? "GET",
    credentials: "include",
    headers: {
      "Content-Type": "application/json",
    },
    body: options.body ? JSON.stringify(options.body) : undefined,
  });

  if (!response.ok) {
    let message = "Error inesperado";

    try {
      const errorData = await response.json();
      if (typeof errorData?.message === "string") {
        message = errorData.message;
      } else if (Array.isArray(errorData?.message)) {
        message = errorData.message.join(", ");
      }
    } catch {
      // noop
    }

    throw new Error(message);
  }

  return response.json() as Promise<T>;
}

export const authService = {
  login(payload: LoginRequestDto): Promise<AuthResponseDto> {
    return request<AuthResponseDto>("/auth/login", {
      method: "POST",
      body: payload,
    });
  },

  register(payload: RegisterRequestDto): Promise<AuthResponseDto> {
    return request<AuthResponseDto>("/auth/register", {
      method: "POST",
      body: payload,
    });
  },

  me(): Promise<AuthUser> {
    return request<AuthUser>("/auth/me");
  },

  refresh(): Promise<AuthResponseDto> {
    return request<AuthResponseDto>("/auth/refresh", {
      method: "POST",
      body: {},
    });
  },

  logout(): Promise<{ success: true }> {
    return request<{ success: true }>("/auth/logout", {
      method: "POST",
      body: {},
    });
  },

  updateUser(
    id: string,
    payload: { fullName?: string; password?: string },
  ): Promise<AuthUser> {
    return request<AuthUser>(`/users/${id}`, {
      method: "PATCH",
      body: payload,
    });
  },
};
