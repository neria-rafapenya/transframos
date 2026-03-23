import ReactDOM from "react-dom/client";
import { MemoryRouter } from "react-router-dom";
import AppProviders from "@/app/providers/AppProviders";
import AppRouter from "@/app/router";
import "./scss/index.scss";

type MountOptions = {
  container?: string | HTMLElement;
};

type WidgetApi = {
  mount: (options?: MountOptions) => void;
  unmount: () => void;
};

declare global {
  interface Window {
    TransframosWidget?: WidgetApi;
  }
}

let root: ReactDOM.Root | null = null;

function resolveContainer(container?: string | HTMLElement): HTMLElement {
  if (typeof container === "string") {
    const found = document.querySelector<HTMLElement>(container);

    if (!found) {
      throw new Error(`No se encontró el contenedor del widget: ${container}`);
    }

    return found;
  }

  if (container instanceof HTMLElement) {
    return container;
  }

  const defaultId = "transframos-widget-root";
  let defaultContainer = document.getElementById(defaultId);

  if (!defaultContainer) {
    defaultContainer = document.createElement("div");
    defaultContainer.id = defaultId;
    document.body.appendChild(defaultContainer);
  }

  return defaultContainer;
}

function mount(options?: MountOptions): void {
  const container = resolveContainer(options?.container);

  if (root) {
    return;
  }

  root = ReactDOM.createRoot(container);

  root.render(
    <MemoryRouter>
      <AppProviders>
        <AppRouter />
      </AppProviders>
    </MemoryRouter>,
  );
}

function unmount(): void {
  if (root) {
    root.unmount();
    root = null;
  }
}

window.TransframosWidget = {
  mount,
  unmount,
};
