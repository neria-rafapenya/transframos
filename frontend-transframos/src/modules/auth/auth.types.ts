export type AuthUser = {
  id: string;
  email: string;
  fullName: string;
  role: "admin" | "operator" | "client";
  isActive: boolean;
  createdAt: string;
  updatedAt: string;
};

export type LoginRequestDto = {
  email: string;
  password: string;
};

export type AuthResponseDto = {
  sessionId: string;
  user: AuthUser;
};

export type AuthState = {
  user: AuthUser | null;
  sessionId: string | null;
  isAuthenticated: boolean;
  isLoading: boolean;
  isBootstrapping: boolean;
};

export type AuthActions = {
  bootstrapAuth: () => Promise<void>;
  login: (email: string, password: string) => Promise<void>;
  logout: () => Promise<void>;
  clearSession: () => void;
};

export type AuthStore = AuthState & AuthActions;
