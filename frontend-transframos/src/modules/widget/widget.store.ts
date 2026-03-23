import { create } from "zustand";
import { persist } from "zustand/middleware";
import type { WidgetStore } from "./widget.types";

export const useWidgetStore = create<WidgetStore>()(
  persist(
    (set, get) => ({
      isOpen: false,
      isMinimized: true,
      isExpanded: false,
      width: 1200,
      height: 800,
      launcherPoint: null,

      open: (launcherPoint) =>
        set({
          isOpen: true,
          isMinimized: false,
          launcherPoint: launcherPoint ?? get().launcherPoint,
        }),

      minimize: () =>
        set({
          isOpen: false,
          isMinimized: true,
        }),

      close: () =>
        set({
          isOpen: false,
          isMinimized: true,
        }),

      toggleExpanded: () =>
        set((state) => ({
          isExpanded: !state.isExpanded,
        })),

      setSize: (width: number, height: number) =>
        set({
          width,
          height,
        }),
    }),
    {
      name: "transframos-widget-state",
      partialize: (state) => ({
        isOpen: state.isOpen,
        isMinimized: state.isMinimized,
        isExpanded: state.isExpanded,
        width: state.width,
        height: state.height,
        launcherPoint: state.launcherPoint,
      }),
    },
  ),
);
