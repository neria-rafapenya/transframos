import type { PropsWithChildren } from "react";
import { useEffect, useLayoutEffect, useRef } from "react";
import { useWidgetStore } from "@/modules/widget/widget.store";

type WidgetFrameProps = PropsWithChildren<{
  isClosing?: boolean;
}>;

const WidgetFrame = ({ children, isClosing }: WidgetFrameProps) => {
  const width = useWidgetStore((state) => state.width);
  const height = useWidgetStore((state) => state.height);
  const isExpanded = useWidgetStore((state) => state.isExpanded);
  const launcherPoint = useWidgetStore((state) => state.launcherPoint);
  const closeWidget = useWidgetStore((state) => state.close);
  const frameRef = useRef<HTMLDivElement>(null);

  const updateOrigin = () => {
    const frame = frameRef.current;

    if (!frame) {
      return;
    }

    if (!launcherPoint) {
      frame.style.removeProperty("--widget-origin-x");
      frame.style.removeProperty("--widget-origin-y");
      return;
    }

    const frameRect = frame.getBoundingClientRect();
    const originX = launcherPoint.x - frameRect.left;
    const originY = launcherPoint.y - frameRect.top;

    if (!Number.isFinite(originX) || !Number.isFinite(originY)) {
      return;
    }

    frame.style.setProperty("--widget-origin-x", `${originX}px`);
    frame.style.setProperty("--widget-origin-y", `${originY}px`);
  };

  useLayoutEffect(() => {
    updateOrigin();
  }, [launcherPoint, width, height, isExpanded]);

  useEffect(() => {
    if (!launcherPoint) {
      return;
    }

    const handleResize = () => updateOrigin();
    window.addEventListener("resize", handleResize);

    return () => window.removeEventListener("resize", handleResize);
  }, [launcherPoint, width, height, isExpanded]);

  const resolvedWidth = isExpanded
    ? "calc(100vw - 32px)"
    : `min(${width}px, calc(100vw - 32px))`;

  const resolvedHeight = isExpanded
    ? "calc(100vh - 32px)"
    : `min(${height}px, calc(100vh - 32px))`;

  return (
    <div
      className={`widget-overlay${isClosing ? " widget-overlay--closing" : ""}`}
    >
      <div
        className={`widget-frame${isClosing ? " widget-frame--closing" : ""}`}
        ref={frameRef}
        style={{
          width: resolvedWidth,
          height: resolvedHeight,
        }}
      >
        <div className="widget-frame__body">
          <div className="widget-frame__header">
            <button
              type="button"
              className="widget-frame__close"
              aria-label="Cerrar widget"
              title="Cerrar widget"
              onClick={closeWidget}
            >
              <svg viewBox="0 0 24 24" aria-hidden="true">
                <path
                  d="M6 6L18 18M18 6L6 18"
                  stroke="currentColor"
                  strokeWidth="2"
                  strokeLinecap="round"
                />
              </svg>
            </button>
          </div>
          {children}
        </div>
      </div>
    </div>
  );
};

export default WidgetFrame;
