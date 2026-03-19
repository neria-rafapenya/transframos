import type { PropsWithChildren } from "react";
import { useEffect } from "react";
import { useAuthStore } from "@/modules/auth/auth.store";

const AppProviders = ({ children }: PropsWithChildren) => {
  const bootstrapAuth = useAuthStore((state) => state.bootstrapAuth);
  const isBootstrapping = useAuthStore((state) => state.isBootstrapping);

  useEffect(() => {
    void bootstrapAuth();
  }, [bootstrapAuth]);

  if (isBootstrapping) {
    return (
      <div
        style={{
          minHeight: "100vh",
          display: "grid",
          placeItems: "center",
          background: "#f3f4f6",
          padding: "24px",
        }}
      >
        <div
          style={{
            background: "white",
            borderRadius: "20px",
            padding: "32px",
            minWidth: "320px",
            boxShadow: "0 12px 32px rgba(15, 23, 42, 0.08)",
            textAlign: "center",
          }}
        >
          <h2>Inicializando sesión</h2>
          <p>Comprobando credenciales...</p>
        </div>
      </div>
    );
  }

  return children;
};

export default AppProviders;
