import { useState } from "react";
import { useNavigate } from "react-router-dom";
import { useAuthStore } from "@/modules/auth/auth.store";
import Logotipo from "@/components/ui/Logotipo";

const LoginPage = () => {
  const navigate = useNavigate();
  const login = useAuthStore((state) => state.login);
  const isLoading = useAuthStore((state) => state.isLoading);

  const [email, setEmail] = useState("admin@transframos.local");
  const [password, setPassword] = useState("123456");
  const [error, setError] = useState("");

  const handleSubmit = async (event: React.FormEvent<HTMLFormElement>) => {
    event.preventDefault();
    setError("");

    try {
      await login(email, password);
      navigate("/dashboard");
    } catch (err) {
      setError(
        err instanceof Error ? err.message : "No se pudo iniciar sesión",
      );
    }
  };

  return (
    <div className="login-page">
      <div className="login-card">
        <div className="login-card__header text-center">
          <Logotipo width={188} height={48} color="#00A58F" />

          <p>Asistente Inteligente de pedidos</p>
        </div>

        <form className="login-form" onSubmit={handleSubmit}>
          <label className="field">
            <span>Email</span>
            <input
              type="email"
              value={email}
              onChange={(event) => setEmail(event.target.value)}
              placeholder="usuario@empresa.com"
            />
          </label>

          <label className="field">
            <span>Contraseña</span>
            <input
              type="password"
              value={password}
              onChange={(event) => setPassword(event.target.value)}
              placeholder="******"
            />
          </label>

          {error ? <div className="alert alert-error">{error}</div> : null}

          <button
            type="submit"
            className="primary-button full-width"
            disabled={isLoading}
          >
            {isLoading ? "Entrando..." : "Entrar"}
          </button>
        </form>
      </div>
    </div>
  );
};

export default LoginPage;
