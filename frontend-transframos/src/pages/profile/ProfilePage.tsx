import { useEffect, useState, type FormEvent } from "react";
import { useAuthStore } from "@/modules/auth/auth.store";

const ProfilePage = () => {
  const user = useAuthStore((state) => state.user);
  const isLoading = useAuthStore((state) => state.isLoading);
  const updateProfile = useAuthStore((state) => state.updateProfile);
  const [fullName, setFullName] = useState(user?.fullName ?? "");
  const [password, setPassword] = useState("");
  const [passwordConfirm, setPasswordConfirm] = useState("");
  const [error, setError] = useState<string | null>(null);
  const [success, setSuccess] = useState<string | null>(null);

  useEffect(() => {
    setFullName(user?.fullName ?? "");
  }, [user?.fullName]);

  const handleSubmit = async (event: FormEvent) => {
    event.preventDefault();
    setError(null);
    setSuccess(null);

    const trimmedName = fullName.trim();
    if (!trimmedName) {
      setError("El nombre es obligatorio.");
      return;
    }

    if (password) {
      if (password.length < 6) {
        setError("La contrasena debe tener al menos 6 caracteres.");
        return;
      }
      if (password !== passwordConfirm) {
        setError("Las contrasenas no coinciden.");
        return;
      }
    }

    try {
      await updateProfile({
        fullName: trimmedName,
        password: password ? password : undefined,
      });
      setPassword("");
      setPasswordConfirm("");
      setSuccess("Perfil actualizado correctamente.");
    } catch (err) {
      setError(err instanceof Error ? err.message : "No se pudo actualizar.");
    }
  };

  return (
    <div className="dashboard-page">
      <section className="panel">
        <h2>Mi perfil</h2>
        <p>Edita tu nombre y tu contrasena.</p>

        <form className="profile-form" onSubmit={handleSubmit}>
          <label>
            Nombre
            <input
              type="text"
              value={fullName}
              onChange={(event) => setFullName(event.target.value)}
              placeholder="Tu nombre"
              required
            />
          </label>
          <label>
            Nueva contrasena
            <input
              type="password"
              value={password}
              onChange={(event) => setPassword(event.target.value)}
              placeholder="Deja en blanco para no cambiarla"
            />
          </label>
          <label>
            Confirmar contrasena
            <input
              type="password"
              value={passwordConfirm}
              onChange={(event) => setPasswordConfirm(event.target.value)}
              placeholder="Repite la contrasena"
            />
          </label>

          {error ? <p className="profile-form__error">{error}</p> : null}
          {success ? <p className="profile-form__success">{success}</p> : null}

          <button className="primary-button" type="submit" disabled={isLoading}>
            Guardar cambios
          </button>
        </form>

        <div className="profile-grid">
          <div>
            <span>Nombre</span>
            <strong>{user?.fullName ?? "-"}</strong>
          </div>
          <div>
            <span>Email</span>
            <strong>{user?.email ?? "-"}</strong>
          </div>
          <div>
            <span>Rol</span>
            <strong>{user?.role ?? "-"}</strong>
          </div>
          <div>
            <span>Tipo de cliente</span>
            <strong>{user?.clientType ?? "-"}</strong>
          </div>
          <div>
            <span>Activo</span>
            <strong>{user?.isActive ? "Sí" : "No"}</strong>
          </div>
        </div>
      </section>
    </div>
  );
};

export default ProfilePage;
