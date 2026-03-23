export type AuthUser = {
  id: string;
  email: string;
  fullName: string;
  role: "admin" | "operator" | "client";
  clientType: "fidelizado" | "nuevo";
  isActive: boolean;
  dni?: string | null;
  nif?: string | null;
  companyName?: string | null;
  companyHqAddress?: string | null;
  contactName?: string | null;
  contactPhone?: string | null;
  contactPhoneAlt?: string | null;
  contactEmail?: string | null;
  createdAt: string;
  updatedAt: string;
};

export type LoginRequestDto = {
  email: string;
  password: string;
};

export type RegisterRequestDto = {
  email: string;
  password: string;
  fullName?: string;
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
  register: (email: string, password: string) => Promise<void>;
  logout: () => Promise<void>;
  updateProfile: (payload: {
    fullName?: string;
    password?: string;
  }) => Promise<void>;
  clearSession: () => void;
};

export type AuthStore = AuthState & AuthActions;
