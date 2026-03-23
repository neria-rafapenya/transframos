import { useState } from "react";
import { useNavigate, Link } from "react-router-dom";
import { useAuthStore } from "@/modules/auth/auth.store";
import Logotipo from "@/components/ui/Logotipo";

const RegisterPage = () => {
  const navigate = useNavigate();
  const register = useAuthStore((state) => state.register);
  const isLoading = useAuthStore((state) => state.isLoading);

  const [fullName, setFullName] = useState("");
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [error, setError] = useState("");

  const handleSubmit = async (event: React.FormEvent<HTMLFormElement>) => {
    event.preventDefault();
    setError("");

    try {
      await register(fullName, email, password);
      navigate("/dashboard");
    } catch (err) {
      setError(
        err instanceof Error ? err.message : "No se pudo crear la cuenta",
      );
    }
  };

  return (
    <div className="login-page">
      <div className="login-card">
        <div className="login-card__header text-center">
          <Logotipo width={188} height={48} color="#00A58F" />

          <p>Crear cuenta de cliente</p>
        </div>

        <form className="login-form" onSubmit={handleSubmit}>
          <label className="field">
            <span>Nombre completo</span>
            <input
              type="text"
              value={fullName}
              onChange={(event) => setFullName(event.target.value)}
              placeholder="Nombre y apellidos"
              required
            />
          </label>

          <label className="field">
            <span>Email</span>
            <input
              type="email"
              value={email}
              onChange={(event) => setEmail(event.target.value)}
              placeholder="usuario@empresa.com"
              required
            />
          </label>

          <label className="field">
            <span>Contraseña</span>
            <input
              type="password"
              value={password}
              onChange={(event) => setPassword(event.target.value)}
              placeholder="Mínimo 6 caracteres"
              required
              minLength={6}
            />
          </label>

          {error ? <div className="alert alert-error">{error}</div> : null}

          <button
            type="submit"
            className="primary-button full-width"
            disabled={isLoading}
          >
            {isLoading ? "Creando..." : "Crear cuenta"}
          </button>
        </form>

        <div className="login-card__footer text-center">
          <span>¿Ya tienes cuenta? </span>
          <Link to="/login">Inicia sesión</Link>
        </div>
      </div>
    </div>
  );
};

export default RegisterPage;
