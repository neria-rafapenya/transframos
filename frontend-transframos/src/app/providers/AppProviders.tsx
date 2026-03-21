import type { PropsWithChildren } from "react";
import { useEffect } from "react";
import { useLocation, useNavigate } from "react-router-dom";
import { useAuthStore } from "@/modules/auth/auth.store";
import WidgetShell from "@/components/widget/WidgetShell";

const AppProviders = ({ children }: PropsWithChildren) => {
  const bootstrapAuth = useAuthStore((state) => state.bootstrapAuth);
  const isBootstrapping = useAuthStore((state) => state.isBootstrapping);
  const isAuthenticated = useAuthStore((state) => state.isAuthenticated);
  const navigate = useNavigate();
  const location = useLocation();

  useEffect(() => {
    void bootstrapAuth();
  }, [bootstrapAuth]);

  useEffect(() => {
    if (isBootstrapping) {
      return;
    }

    if (!isAuthenticated && location.pathname !== "/login") {
      navigate("/login", { replace: true });
    }
  }, [isAuthenticated, isBootstrapping, location.pathname, navigate]);

  return (
    <WidgetShell>
      {isBootstrapping ? (
        <div className="widget-loading-screen">
          <div className="widget-loading-card">
            <h2>Inicializando sesión</h2>
            <p>Comprobando credenciales y contexto del widget...</p>
          </div>
        </div>
      ) : (
        children
      )}
    </WidgetShell>
  );
};

export default AppProviders;
