export type WidgetLauncherPoint = {
  x: number;
  y: number;
};

export type WidgetState = {
  isOpen: boolean;
  isMinimized: boolean;
  isExpanded: boolean;
  width: number;
  height: number;
  launcherPoint: WidgetLauncherPoint | null;
};

export type WidgetActions = {
  open: (launcherPoint?: WidgetLauncherPoint) => void;
  minimize: () => void;
  close: () => void;
  toggleExpanded: () => void;
  setSize: (width: number, height: number) => void;
};

export type WidgetStore = WidgetState & WidgetActions;
