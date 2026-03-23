import type { ReactNode } from "react";
import { useEffect, useRef, useState } from "react";
import { useLocation, useNavigationType, useOutlet } from "react-router-dom";

const TRANSITION_MS = 260;

const getTransitionDelay = () => {
  if (typeof window === "undefined") {
    return TRANSITION_MS;
  }

  return window.matchMedia("(prefers-reduced-motion: reduce)").matches
    ? 0
    : TRANSITION_MS;
};

const PageTransition = () => {
  const location = useLocation();
  const navigationType = useNavigationType();
  const outlet = useOutlet();

  const [currentOutlet, setCurrentOutlet] = useState(outlet);
  const [previousOutlet, setPreviousOutlet] = useState<ReactNode | null>(null);
  const [direction, setDirection] = useState<"forward" | "back">("forward");
  const lastLocationId = useRef(
    `${location.pathname}${location.search}${location.hash}`,
  );
  const currentOutletRef = useRef(currentOutlet);

  useEffect(() => {
    currentOutletRef.current = currentOutlet;
  }, [currentOutlet]);

  useEffect(() => {
    const locationId = `${location.pathname}${location.search}${location.hash}`;

    if (locationId === lastLocationId.current) {
      return;
    }

    setPreviousOutlet(currentOutletRef.current);
    setCurrentOutlet(outlet);
    setDirection(navigationType === "POP" ? "back" : "forward");
    lastLocationId.current = locationId;
  }, [location.hash, location.pathname, location.search, navigationType, outlet]);

  useEffect(() => {
    if (!previousOutlet) {
      return;
    }

    const timeoutId = window.setTimeout(() => {
      setPreviousOutlet(null);
    }, getTransitionDelay());

    return () => window.clearTimeout(timeoutId);
  }, [previousOutlet]);

  const isTransitioning = Boolean(previousOutlet);

  return (
    <div
      className={`page-transition${
        isTransitioning ? ` page-transition--${direction}` : ""
      }`}
      data-transitioning={isTransitioning ? "true" : "false"}
    >
      <div className="page-transition__pane page-transition__pane--current">
        {currentOutlet}
      </div>

      {previousOutlet ? (
        <div className="page-transition__pane page-transition__pane--previous">
          {previousOutlet}
        </div>
      ) : null}
    </div>
  );
};

export default PageTransition;
