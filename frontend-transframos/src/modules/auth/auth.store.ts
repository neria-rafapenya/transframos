import { create } from "zustand";
import { authService } from "./auth.service";
import type { AuthStore } from "./auth.types";

const SESSION_HINT_KEY = "transframos-session-hint";
const SESSION_HINT_COOKIE = "tra_session_hint";

const getSessionHintCookie = () => {
  if (typeof document === "undefined") {
    return null;
  }

  const cookies = document.cookie.split("; ");
  const entry = cookies.find((cookie) =>
    cookie.startsWith(`${SESSION_HINT_COOKIE}=`),
  );

  if (!entry) {
    return null;
  }

  const [, value] = entry.split("=");
  return value ?? null;
};

const hasSessionHint = () => {
  if (typeof window === "undefined") {
    return false;
  }

  const cookieHint = getSessionHintCookie();

  if (cookieHint) {
    return true;
  }

  const localHint = window.localStorage.getItem(SESSION_HINT_KEY);

  if (localHint) {
    window.localStorage.removeItem(SESSION_HINT_KEY);
  }

  return false;
};

const setSessionHint = (value: boolean) => {
  if (typeof window === "undefined") {
    return;
  }

  if (value) {
    window.localStorage.setItem(SESSION_HINT_KEY, "1");
  } else {
    window.localStorage.removeItem(SESSION_HINT_KEY);
  }
};

export const useAuthStore = create<AuthStore>((set) => ({
  user: null,
  sessionId: null,
  isAuthenticated: false,
  isLoading: false,
  isBootstrapping: true,

  clearSession: () => {
    setSessionHint(false);
    set({
      user: null,
      sessionId: null,
      isAuthenticated: false,
    });
  },

  bootstrapAuth: async () => {
    if (!hasSessionHint()) {
      set({
        user: null,
        sessionId: null,
        isAuthenticated: false,
        isBootstrapping: false,
      });
      return;
    }

    try {
      const user = await authService.me();

      setSessionHint(true);
      set({
        user,
        isAuthenticated: true,
        isBootstrapping: false,
      });
    } catch {
      try {
        const refreshed = await authService.refresh();

        setSessionHint(true);
        set({
          user: refreshed.user,
          sessionId: refreshed.sessionId,
          isAuthenticated: true,
          isBootstrapping: false,
        });
      } catch {
        setSessionHint(false);
        set({
          user: null,
          sessionId: null,
          isAuthenticated: false,
          isBootstrapping: false,
        });
      }
    }
  },

  login: async (email: string, password: string) => {
    set({ isLoading: true });

    try {
      const response = await authService.login({ email, password });

      setSessionHint(true);
      set({
        user: response.user,
        sessionId: response.sessionId,
        isAuthenticated: true,
        isLoading: false,
      });
    } catch (error) {
      set({ isLoading: false });
      throw error;
    }
  },

  register: async (email: string, password: string) => {
    set({ isLoading: true });

    try {
      const response = await authService.register({
        email,
        password,
      });

      setSessionHint(true);
      set({
        user: response.user,
        sessionId: response.sessionId,
        isAuthenticated: true,
        isLoading: false,
      });
    } catch (error) {
      set({ isLoading: false });
      throw error;
    }
  },

  logout: async () => {
    try {
      await authService.logout();
    } catch {
      // aunque falle, limpiamos estado local
    } finally {
      setSessionHint(false);
      set({
        user: null,
        sessionId: null,
        isAuthenticated: false,
      });
    }
  },

  updateProfile: async (payload) => {
    const currentUser = useAuthStore.getState().user;
    if (!currentUser) {
      return;
    }

    set({ isLoading: true });

    try {
      const updated = await authService.updateUser(currentUser.id, payload);
      set({
        user: updated,
        isLoading: false,
      });
    } catch (error) {
      set({ isLoading: false });
      throw error;
    }
  },
}));
