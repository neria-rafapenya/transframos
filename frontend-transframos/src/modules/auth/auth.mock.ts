import type { AuthUser } from "./auth.types";
import { mockDelay } from "@/services/mockDelay";

const MOCK_PASSWORD = "123456";

const MOCK_USER: AuthUser = {
  id: "client-001",
  fullName: "Rafa P. Vargas",
  email: "cliente@zumosrios.com",
  companyName: "Zumos Ríos SL",
  clientCode: "ZR-001",
  phone: "+34 600 000 000",
  defaultLoadingPoint: "Planta Zaragoza Norte",
  defaultUnloadingPoint: "Centro logístico Barcelona Zona Franca",
};

export const mockLoginRequest = async (
  email: string,
  password: string,
): Promise<AuthUser> => {
  await mockDelay(700);

  if (email !== MOCK_USER.email || password !== MOCK_PASSWORD) {
    throw new Error("Credenciales incorrectas");
  }

  return MOCK_USER;
};
