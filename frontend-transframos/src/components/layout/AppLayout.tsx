import { useMemo, useState } from "react";
import { NavLink, useNavigate } from "react-router-dom";
import {
  LayoutDashboard,
  MessageSquareText,
  ShieldCheck,
  Users,
  Settings,
  UserRound,
  ClipboardList,
  Bot,
  Menu,
  Maximize2,
  Minimize2,
  X,
  LogOut,
} from "lucide-react";
import { useAuthStore } from "@/modules/auth/auth.store";
import { useWidgetStore } from "@/modules/widget/widget.store";
import Logotipo from "@/components/ui/Logotipo";
import PageTransition from "./PageTransition";

type NavItem = {
  to: string;
  label: string;
  icon: React.ReactNode;
};

const AppLayout = () => {
  const navigate = useNavigate();
  const user = useAuthStore((state) => state.user);
  const logout = useAuthStore((state) => state.logout);

  const closeWidget = useWidgetStore((state) => state.close);
  const toggleExpanded = useWidgetStore((state) => state.toggleExpanded);
  const isExpanded = useWidgetStore((state) => state.isExpanded);

  const [mobileMenuOpen, setMobileMenuOpen] = useState(false);

  const isAdmin = user?.role === "admin";

  const navigation = useMemo<NavItem[]>(() => {
    if (isAdmin) {
      return [
        {
          to: "/dashboard",
          label: "Dashboard",
          icon: <LayoutDashboard size={18} />,
        },
        { to: "/users", label: "Usuarios", icon: <Users size={18} /> },
        { to: "/sessions", label: "Sesiones", icon: <ShieldCheck size={18} /> },
        { to: "/llm-actions", label: "Acciones LLM", icon: <Bot size={18} /> },
        {
          to: "/settings",
          label: "Configuración",
          icon: <Settings size={18} />,
        },
      ];
    }

    return [
      {
        to: "/dashboard",
        label: "Dashboard",
        icon: <LayoutDashboard size={18} />,
      },
      {
        to: "/assistant",
        label: "Asistente IA",
        icon: <MessageSquareText size={18} />,
      },
      {
        to: "/orders",
        label: "Pedidos",
        icon: <ClipboardList size={18} />,
      },
      {
        to: "/profile",
        label: "Perfil",
        icon: <UserRound size={18} />,
      },
    ];
  }, [isAdmin]);

  const handleLogout = async () => {
    setMobileMenuOpen(false);
    await logout();
    navigate("/login");
  };

  const handleCloseWidget = () => {
    setMobileMenuOpen(false);
    closeWidget();
  };

  const handleNavigate = () => {
    setMobileMenuOpen(false);
  };

  return (
    <div className="app-shell app-shell--navbar">
      <header className="topbar topbar--navbar">
        <nav className="navbar navbar-expand-lg app-navbar">
          <div className="container-fluid app-navbar__container">
            <div className="app-navbar__brand ps-4">
              <Logotipo width={168} height={28} color="#ffffff" />
            </div>

            <div className="app-navbar__center d-none d-lg-flex">
              {navigation.map((item) => (
                <NavLink
                  key={item.to}
                  to={item.to}
                  onClick={handleNavigate}
                  className={({ isActive }) =>
                    isActive
                      ? "app-navbar__link app-navbar__link--active"
                      : "app-navbar__link"
                  }
                >
                  <span>{item.label}</span>
                </NavLink>
              ))}
            </div>

            <div className="app-navbar__actions">
              <button
                type="button"
                className="app-navbar__icon-button d-none d-lg-inline-flex"
                onClick={handleLogout}
              >
                <LogOut size={16} />
              </button>

              <button
                type="button"
                className="app-navbar__icon-button"
                onClick={toggleExpanded}
                title={isExpanded ? "Restaurar tamaño" : "Expandir widget"}
                aria-label={isExpanded ? "Restaurar tamaño" : "Expandir widget"}
              >
                {isExpanded ? <Minimize2 size={18} /> : <Maximize2 size={18} />}
              </button>

              <button
                type="button"
                className="app-navbar__icon-button"
                onClick={handleCloseWidget}
                title="Cerrar widget"
                aria-label="Cerrar widget"
              >
                <X size={18} />
              </button>

              <button
                type="button"
                className="app-navbar__icon-button app-navbar__menu-button d-lg-none"
                onClick={() => setMobileMenuOpen((prev) => !prev)}
                title="Abrir menú"
                aria-label="Abrir menú"
              >
                <Menu size={18} />
              </button>
            </div>

            {mobileMenuOpen ? (
              <div className="app-navbar__mobile-panel d-lg-none">
                <div className="app-navbar__mobile-links">
                  {navigation.map((item) => (
                    <NavLink
                      key={item.to}
                      to={item.to}
                      onClick={handleNavigate}
                      className={({ isActive }) =>
                        isActive
                          ? "app-navbar__mobile-link app-navbar__mobile-link--active"
                          : "app-navbar__mobile-link"
                      }
                    >
                      {item.icon}
                      <span>{item.label}</span>
                    </NavLink>
                  ))}
                </div>

                <button
                  type="button"
                  className="app-navbar__mobile-logout"
                  onClick={handleLogout}
                >
                  <LogOut size={16} />
                  <span>Cerrar sesión</span>
                </button>
              </div>
            ) : null}
          </div>
        </nav>
      </header>

      <main className="main-content main-content--navbar">
        <section className="page-content page-content--navbar">
          <PageTransition />
        </section>
      </main>
    </div>
  );
};

export default AppLayout;
