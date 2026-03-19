import { useAuthStore } from "@/modules/auth/auth.store";
import { FileText, MessageSquareText, PackageCheck, Truck } from "lucide-react";
import { useNavigate } from "react-router-dom";

const DashboardPage = () => {
  const navigate = useNavigate();
  const user = useAuthStore((state) => state.user);

  return (
    <div className="dashboard-page">
      <div className="hero-card">
        <div>
          <h2>Hola, {user?.fullName}</h2>
          <p>
            Bienvenido al portal de {user?.companyName}. Desde aquí podrás
            iniciar pedidos, consultar estado y utilizar el asistente
            inteligente.
          </p>
        </div>

        <button
          className="primary-button"
          onClick={() => navigate("/assistant")}
        >
          <MessageSquareText size={16} />
          Iniciar nuevo pedido con IA
        </button>
      </div>

      <div className="stats-grid">
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
      </div>

      <div className="content-grid">
        <section className="panel">
          <h3>Accesos rápidos</h3>
          <div className="quick-actions">
            <button
              className="secondary-button"
              onClick={() => navigate("/assistant")}
            >
              Nuevo pedido
            </button>
            <button className="secondary-button">Repetir último pedido</button>
            <button className="secondary-button">Ver documentación</button>
          </div>
        </section>

        <section className="panel">
          <h3>Último pedido simulado</h3>
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
        </section>
      </div>
    </div>
  );
};

export default DashboardPage;
