import { NavLink, Outlet, useNavigate } from "react-router-dom";
import {
  LayoutDashboard,
  LogOut,
  MessageSquareText,
  Truck,
} from "lucide-react";
import { useAuthStore } from "@/modules/auth/auth.store";

const AppLayout = () => {
  const navigate = useNavigate();
  const user = useAuthStore((state) => state.user);
  const logout = useAuthStore((state) => state.logout);

  const handleLogout = async () => {
    await logout();
    navigate("/login");
  };

  return (
    <div className="app-shell">
      <aside className="sidebar">
        <div>
          <div className="brand">
            <Truck size={22} />
            <div>
              <strong>Transframos Demo</strong>
              <small>Portal cliente</small>
            </div>
          </div>

          <nav className="nav">
            <NavLink
              to="/dashboard"
              className={({ isActive }) =>
                isActive ? "nav-link active" : "nav-link"
              }
            >
              <LayoutDashboard size={18} />
              Dashboard
            </NavLink>

            <NavLink
              to="/assistant"
              className={({ isActive }) =>
                isActive ? "nav-link active" : "nav-link"
              }
            >
              <MessageSquareText size={18} />
              Asistente IA
            </NavLink>
          </nav>
        </div>

        <div className="sidebar-footer">
          <div className="user-card">
            <div className="user-card__name">{user?.fullName ?? "Usuario"}</div>
            <div className="user-card__company">
              {user?.email ?? "Sin email"}
            </div>
          </div>

          <button
            className="secondary-button full-width"
            onClick={handleLogout}
          >
            <LogOut size={16} />
            Cerrar sesión
          </button>
        </div>
      </aside>

      <main className="main-content">
        <header className="topbar">
          <div>
            <h1 className="topbar-title">Portal de clientes fidelizados</h1>
            <p className="topbar-subtitle">
              Gestión rápida de pedidos y asistente inteligente
            </p>
          </div>
        </header>

        <section className="page-content">
          <Outlet />
        </section>
      </main>
    </div>
  );
};

export default AppLayout;
