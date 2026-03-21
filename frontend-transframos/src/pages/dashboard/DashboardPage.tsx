import { useNavigate } from "react-router-dom";
import {
  FileText,
  MessageSquareText,
  PackageCheck,
  ShieldCheck,
  Bot,
  Users,
  Truck,
} from "lucide-react";
import { useAuthStore } from "@/modules/auth/auth.store";

const DashboardPage = () => {
  const navigate = useNavigate();
  const user = useAuthStore((state) => state.user);

  const isAdmin = user?.role === "admin";

  return (
    <div className="dashboard-page">
      <div className="hero-card">
        <div>
          <h2>Hola, {user?.fullName}</h2>
          <p>
            {isAdmin
              ? "Estás dentro del backoffice embebido. Desde aquí podrás gestionar usuarios, sesiones y trazas del asistente."
              : "Bienvenido al portal de cliente. Desde aquí podrás iniciar pedidos y utilizar el asistente inteligente."}
          </p>
        </div>

        <button
          className="primary-button"
          onClick={() => navigate(isAdmin ? "/users" : "/assistant")}
        >
          {isAdmin ? (
            <>
              <Users size={16} />
              Ir a usuarios
            </>
          ) : (
            <>
              <MessageSquareText size={16} />
              Iniciar pedido con IA
            </>
          )}
        </button>
      </div>

      <div className="stats-grid">
        {isAdmin ? (
          <>
            <article className="stat-card">
              <div className="stat-card__icon">
                <Users size={18} />
              </div>
              <div>
                <strong>2</strong>
                <p>Usuarios demo</p>
              </div>
            </article>

            <article className="stat-card">
              <div className="stat-card__icon">
                <ShieldCheck size={18} />
              </div>
              <div>
                <strong>3</strong>
                <p>Sesiones activas</p>
              </div>
            </article>

            <article className="stat-card">
              <div className="stat-card__icon">
                <Bot size={18} />
              </div>
              <div>
                <strong>12</strong>
                <p>Acciones LLM registradas</p>
              </div>
            </article>
          </>
        ) : (
          <>
            <article className="stat-card">
              <div className="stat-card__icon">
                <Truck size={18} />
              </div>
              <div>
                <strong>3</strong>
                <p>Transportes en curso</p>
              </div>
            </article>

            <article className="stat-card">
              <div className="stat-card__icon">
                <PackageCheck size={18} />
              </div>
              <div>
                <strong>12</strong>
                <p>Pedidos este mes</p>
              </div>
            </article>

            <article className="stat-card">
              <div className="stat-card__icon">
                <FileText size={18} />
              </div>
              <div>
                <strong>5</strong>
                <p>Documentos recientes</p>
              </div>
            </article>
          </>
        )}
      </div>

      <div className="content-grid">
        <section className="panel">
          <h3>{isAdmin ? "Accesos de backoffice" : "Accesos rápidos"}</h3>

          <div className="quick-actions">
            {isAdmin ? (
              <>
                <button
                  className="secondary-button"
                  onClick={() => navigate("/users")}
                >
                  Usuarios
                </button>
                <button
                  className="secondary-button"
                  onClick={() => navigate("/sessions")}
                >
                  Sesiones
                </button>
                <button
                  className="secondary-button"
                  onClick={() => navigate("/llm-actions")}
                >
                  Acciones LLM
                </button>
                <button
                  className="secondary-button"
                  onClick={() => navigate("/settings")}
                >
                  Configuración
                </button>
              </>
            ) : (
              <>
                <button
                  className="secondary-button"
                  onClick={() => navigate("/assistant")}
                >
                  Nuevo pedido
                </button>
                <button
                  className="secondary-button"
                  onClick={() => navigate("/orders")}
                >
                  Mis pedidos
                </button>
                <button
                  className="secondary-button"
                  onClick={() => navigate("/profile")}
                >
                  Mi perfil
                </button>
              </>
            )}
          </div>
        </section>

        <section className="panel">
          <h3>{isAdmin ? "Resumen técnico" : "Último pedido simulado"}</h3>

          {isAdmin ? (
            <div className="order-summary">
              <p>
                <strong>Auth:</strong> Cookies HttpOnly activas
              </p>
              <p>
                <strong>Sesiones:</strong> Persistidas en MySQL
              </p>
              <p>
                <strong>LLM:</strong> Provider desacoplado
              </p>
              <p>
                <strong>Widget:</strong> Overlay 1024x800 minimizable
              </p>
            </div>
          ) : (
            <div className="order-summary">
              <p>
                <strong>Producto:</strong> Aceite vegetal
              </p>
              <p>
                <strong>Ruta:</strong> Tarragona → Lyon
              </p>
              <p>
                <strong>Estado:</strong> En tránsito
              </p>
              <p>
                <strong>ETA:</strong> mañana 08:30
              </p>
            </div>
          )}
        </section>
      </div>
    </div>
  );
};

export default DashboardPage;
