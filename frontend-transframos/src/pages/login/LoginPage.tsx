import { useEffect, useState } from "react";
import { useNavigate } from "react-router-dom";
import { useAuthStore } from "@/modules/auth/auth.store";
import Logotipo from "@/components/ui/Logotipo";

type AuthMode = "login" | "register";

const LoginPage = ({ initialMode = "login" }: { initialMode?: AuthMode }) => {
  const navigate = useNavigate();
  const login = useAuthStore((state) => state.login);
  const register = useAuthStore((state) => state.register);
  const isLoading = useAuthStore((state) => state.isLoading);

  const [mode, setMode] = useState<AuthMode>(initialMode);
  const [loginEmail, setLoginEmail] = useState("admin@transframos.local");
  const [loginPassword, setLoginPassword] = useState("123456");
  const [registerEmail, setRegisterEmail] = useState("");
  const [registerPassword, setRegisterPassword] = useState("");
  const [error, setError] = useState("");

  useEffect(() => {
    setMode(initialMode);
  }, [initialMode]);

  const navigateAfterAuth = () => {
    const currentUser = useAuthStore.getState().user;
    if (!currentUser?.fullName?.trim()) {
      navigate("/profile");
      return;
    }
    navigate(currentUser.role === "admin" ? "/dashboard" : "/assistant");
  };

  const handleLoginSubmit = async (
    event: React.FormEvent<HTMLFormElement>,
  ) => {
    event.preventDefault();
    setError("");

    try {
      await login(loginEmail, loginPassword);
      navigateAfterAuth();
    } catch (err) {
      setError(
        err instanceof Error ? err.message : "No se pudo iniciar sesión",
      );
    }
  };

  const handleRegisterSubmit = async (
    event: React.FormEvent<HTMLFormElement>,
  ) => {
    event.preventDefault();
    setError("");

    try {
      await register(registerEmail, registerPassword);
      navigate("/profile");
    } catch (err) {
      setError(
        err instanceof Error ? err.message : "No se pudo crear la cuenta",
      );
    }
  };

  return (
    <div className="login-page">
      <div className={`login-card auth-card auth-card--${mode}`}>
        <div className="login-card__header text-center">
          <Logotipo width={188} height={48} color="#00A58F" />

          <p>
            {mode === "login"
              ? "Asistente Inteligente de pedidos"
              : "Crear cuenta de cliente"}
          </p>
        </div>

        <div className="auth-card__panes">
          <form className="login-form auth-card__pane auth-card__pane--login" onSubmit={handleLoginSubmit}>
            <label className="field">
              <span>Email</span>
              <input
                type="email"
                value={loginEmail}
                onChange={(event) => setLoginEmail(event.target.value)}
                placeholder="usuario@empresa.com"
                required
              />
            </label>

            <label className="field">
              <span>Contraseña</span>
              <input
                type="password"
                value={loginPassword}
                onChange={(event) => setLoginPassword(event.target.value)}
                placeholder="******"
                required
              />
            </label>

            {mode === "login" && error ? (
              <div className="alert alert-danger alert-dismissible fade show" role="alert">
                {error}
                <button
                  type="button"
                  className="btn-close"
                  aria-label="Cerrar"
                  onClick={() => setError("")}
                />
              </div>
            ) : null}

            <button
              type="submit"
              className="primary-button full-width"
              disabled={isLoading}
            >
              {isLoading ? "Entrando..." : "Entrar"}
            </button>

            <div className="login-card__footer text-center">
              <span>¿Eres nuevo cliente? </span>
              <button
                type="button"
                className="link-button"
                onClick={() => {
                  setError("");
                  setMode("register");
                }}
              >
                Crea tu cuenta
              </button>
            </div>
          </form>

          <form
            className="login-form auth-card__pane auth-card__pane--register"
            onSubmit={handleRegisterSubmit}
          >
            <label className="field">
              <span>Email</span>
              <input
                type="email"
                value={registerEmail}
                onChange={(event) => setRegisterEmail(event.target.value)}
                placeholder="usuario@empresa.com"
                required
              />
            </label>

            <label className="field">
              <span>Contraseña</span>
              <input
                type="password"
                value={registerPassword}
                onChange={(event) => setRegisterPassword(event.target.value)}
                placeholder="Mínimo 6 caracteres"
                required
                minLength={6}
              />
            </label>

            {mode === "register" && error ? (
              <div className="alert alert-danger alert-dismissible fade show" role="alert">
                {error}
                <button
                  type="button"
                  className="btn-close"
                  aria-label="Cerrar"
                  onClick={() => setError("")}
                />
              </div>
            ) : null}

            <button
              type="submit"
              className="primary-button full-width"
              disabled={isLoading}
            >
              {isLoading ? "Creando..." : "Crear cuenta"}
            </button>

            <div className="login-card__footer text-center">
              <span>¿Ya tienes cuenta? </span>
              <button
                type="button"
                className="link-button"
                onClick={() => {
                  setError("");
                  setMode("login");
                }}
              >
                Inicia sesión
              </button>
            </div>
          </form>
        </div>
      </div>
    </div>
  );
};

export default LoginPage;
