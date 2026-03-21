import { useAuthStore } from "@/modules/auth/auth.store";

const ProfilePage = () => {
  const user = useAuthStore((state) => state.user);

  return (
    <div className="dashboard-page">
      <section className="panel">
        <h2>Mi perfil</h2>

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
            <span>Activo</span>
            <strong>{user?.isActive ? "Sí" : "No"}</strong>
          </div>
        </div>
      </section>
    </div>
  );
};

export default ProfilePage;
