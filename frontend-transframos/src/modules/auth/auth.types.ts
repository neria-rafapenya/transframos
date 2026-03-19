export type AuthUser = {
  id: string;
  fullName: string;
  email: string;
  companyName: string;
  clientCode: string;
  phone: string;
  defaultLoadingPoint: string;
  defaultUnloadingPoint: string;
};

export type AuthState = {
  user: AuthUser | null;
  isAuthenticated: boolean;
  isLoading: boolean;
};

export type AuthActions = {
  login: (email: string, password: string) => Promise<void>;
  logout: () => void;
};

export type AuthStore = AuthState & AuthActions;
