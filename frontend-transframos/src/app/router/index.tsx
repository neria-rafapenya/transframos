import { Navigate, Route, Routes, useLocation } from "react-router-dom";
import LoginPage from "@/pages/login/LoginPage";
import RegisterPage from "@/pages/register/RegisterPage";
import DashboardPage from "@/pages/dashboard/DashboardPage";
import AssistantPage from "@/pages/assistant/AssistantPage";
import UsersPage from "@/pages/users/UsersPage";
import SessionsPage from "@/pages/sessions/SessionsPage";
import LlmActionsPage from "@/pages/llm-actions/LlmActionsPage";
import SettingsPage from "@/pages/settings/SettingsPage";
import OrdersPage from "@/pages/orders/OrdersPage";
import OrderDetailPage from "@/pages/orders/OrderDetailPage";
import ProfilePage from "@/pages/profile/ProfilePage";
import AppLayout from "@/components/layout/AppLayout";
import { useAuthStore } from "@/modules/auth/auth.store";

const PrivateRoute = ({ children }: { children: React.ReactNode }) => {
  const isAuthenticated = useAuthStore((state) => state.isAuthenticated);

  if (!isAuthenticated) {
    return <Navigate to="/login" replace />;
  }

  return children;
};

const ProfileGate = ({ children }: { children: React.ReactNode }) => {
  const user = useAuthStore((state) => state.user);
  const location = useLocation();
  const needsProfile = !user?.fullName?.trim();

  if (user && needsProfile && location.pathname !== "/profile") {
    return <Navigate to="/profile" replace />;
  }

  return children;
};

const PublicRoute = ({ children }: { children: React.ReactNode }) => {
  const isAuthenticated = useAuthStore((state) => state.isAuthenticated);
  const user = useAuthStore((state) => state.user);
  const needsProfile = !user?.fullName?.trim();

  if (isAuthenticated) {
    return <Navigate to={needsProfile ? "/profile" : "/dashboard"} replace />;
  }

  return children;
};

const AdminOnlyRoute = ({ children }: { children: React.ReactNode }) => {
  const user = useAuthStore((state) => state.user);

  if (!user) {
    return <Navigate to="/login" replace />;
  }

  if (user.role !== "admin") {
    return <Navigate to="/dashboard" replace />;
  }

  return children;
};

const UserOnlyRoute = ({ children }: { children: React.ReactNode }) => {
  const user = useAuthStore((state) => state.user);

  if (!user) {
    return <Navigate to="/login" replace />;
  }

  if (user.role === "admin") {
    return <Navigate to="/dashboard" replace />;
  }

  return children;
};

const AppRouter = () => {
  return (
    <Routes>
      <Route
        path="/login"
        element={
          <PublicRoute>
            <LoginPage />
          </PublicRoute>
        }
      />

      <Route
        path="/register"
        element={
          <PublicRoute>
            <RegisterPage />
          </PublicRoute>
        }
      />

      <Route
        path="/"
        element={
          <PrivateRoute>
            <ProfileGate>
              <AppLayout />
            </ProfileGate>
          </PrivateRoute>
        }
      >
        <Route index element={<Navigate to="/dashboard" replace />} />
        <Route path="dashboard" element={<DashboardPage />} />

        <Route
          path="assistant"
          element={
            <UserOnlyRoute>
              <AssistantPage />
            </UserOnlyRoute>
          }
        />

        <Route
          path="orders"
          element={
            <UserOnlyRoute>
              <OrdersPage />
            </UserOnlyRoute>
          }
        />
        <Route
          path="orders/:id"
          element={
            <UserOnlyRoute>
              <OrderDetailPage />
            </UserOnlyRoute>
          }
        />

        <Route path="profile" element={<ProfilePage />} />

        <Route
          path="users"
          element={
            <AdminOnlyRoute>
              <UsersPage />
            </AdminOnlyRoute>
          }
        />

        <Route
          path="sessions"
          element={
            <AdminOnlyRoute>
              <SessionsPage />
            </AdminOnlyRoute>
          }
        />

        <Route
          path="llm-actions"
          element={
            <AdminOnlyRoute>
              <LlmActionsPage />
            </AdminOnlyRoute>
          }
        />
      </Route>

      <Route
        path="/settings"
        element={
          <AdminOnlyRoute>
            <SettingsPage />
          </AdminOnlyRoute>
        }
      />

      <Route path="*" element={<Navigate to="/dashboard" replace />} />
    </Routes>
  );
};

export default AppRouter;
