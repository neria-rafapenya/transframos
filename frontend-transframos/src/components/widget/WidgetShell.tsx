import type { PropsWithChildren } from "react";
import { useEffect, useState } from "react";
import { useWidgetStore } from "@/modules/widget/widget.store";
import WidgetLauncher from "./WidgetLauncher";
import WidgetFrame from "./WidgetFrame";

const CLOSE_ANIMATION_MS = 180;

const getCloseDelay = () => {
  if (typeof window === "undefined") {
    return CLOSE_ANIMATION_MS;
  }

  return window.matchMedia("(prefers-reduced-motion: reduce)").matches
    ? 0
    : CLOSE_ANIMATION_MS;
};

const WidgetShell = ({ children }: PropsWithChildren) => {
  const isOpen = useWidgetStore((state) => state.isOpen);
  const [shouldRender, setShouldRender] = useState(isOpen);
  const [isClosing, setIsClosing] = useState(false);

  useEffect(() => {
    if (isOpen) {
      setShouldRender(true);
      setIsClosing(false);
      return;
    }

    if (!shouldRender) {
      return;
    }

    setIsClosing(true);
    const timeoutId = window.setTimeout(() => {
      setShouldRender(false);
      setIsClosing(false);
    }, getCloseDelay());

    return () => window.clearTimeout(timeoutId);
  }, [isOpen, shouldRender]);

  return (
    <>
      {!isOpen && !shouldRender ? <WidgetLauncher /> : null}
      {shouldRender ? (
        <WidgetFrame isClosing={isClosing}>{children}</WidgetFrame>
      ) : null}
    </>
  );
};

export default WidgetShell;
