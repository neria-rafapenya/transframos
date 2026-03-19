import { create } from "zustand";
import { authService } from "./auth.service";
import type { AuthStore } from "./auth.types";

export const useAuthStore = create<AuthStore>((set) => ({
  user: null,
  sessionId: null,
  isAuthenticated: false,
  isLoading: false,
  isBootstrapping: true,

  clearSession: () => {
    set({
      user: null,
      sessionId: null,
      isAuthenticated: false,
    });
  },

  bootstrapAuth: async () => {
    try {
      const user = await authService.me();

      set({
        user,
        isAuthenticated: true,
        isBootstrapping: false,
      });
    } catch {
      try {
        const refreshed = await authService.refresh();

        set({
          user: refreshed.user,
          sessionId: refreshed.sessionId,
          isAuthenticated: true,
          isBootstrapping: false,
        });
      } catch {
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
      set({
        user: null,
        sessionId: null,
        isAuthenticated: false,
      });
    }
  },
}));
