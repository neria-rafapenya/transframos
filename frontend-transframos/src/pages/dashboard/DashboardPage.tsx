import { useEffect, useRef, useState } from "react";
import { useNavigate } from "react-router-dom";
import {
  FileText,
  MessageSquareText,
  PackageCheck,
  ShieldCheck,
  Bot,
  Users,
  Truck,
  Headset,
  SendHorizonal,
} from "lucide-react";
import { io, type Socket } from "socket.io-client";
import Tippy from "@tippyjs/react";
import { useAuthStore } from "@/modules/auth/auth.store";
import MarkdownText from "@/components/shared/MarkdownText";

type HumanChatMessage = {
  id: string;
  role: "user" | "human" | "system";
  content: string;
  createdAt: string;
};

const HANDOFF_SOCKET_URL =
  import.meta.env.VITE_HANDOFF_SOCKET_URL ?? "http://localhost:5000/handoff";

const DashboardPage = () => {
  const navigate = useNavigate();
  const user = useAuthStore((state) => state.user);

  const isAdmin = user?.role === "admin";
  const [humanChatOpen, setHumanChatOpen] = useState(false);
  const [humanChatStatus, setHumanChatStatus] = useState<
    "idle" | "connecting" | "waiting" | "connected" | "offline"
  >("idle");
  const [humanChatClosing, setHumanChatClosing] = useState(false);
  const [humanChatInput, setHumanChatInput] = useState("");
  const [humanChatMessages, setHumanChatMessages] = useState<HumanChatMessage[]>(
    [],
  );
  const humanSocketRef = useRef<Socket | null>(null);
  const humanCloseTimerRef = useRef<number | null>(null);
  const humanSessionIdRef = useRef<string | null>(null);

  const humanStatusLabel = {
    idle: "Sin iniciar",
    connecting: "Conectando...",
    waiting: "Esperando a un humano...",
    connected: "En conversación",
    offline: "Desconectado",
  }[humanChatStatus];

  const getHumanSessionId = () => {
    if (!humanSessionIdRef.current) {
      humanSessionIdRef.current =
        typeof crypto !== "undefined" && "randomUUID" in crypto
          ? crypto.randomUUID()
          : `human-${Date.now()}-${Math.random().toString(16).slice(2)}`;
    }
    return humanSessionIdRef.current;
  };

  const appendHumanMessage = (message: HumanChatMessage) => {
    setHumanChatMessages((prev) => [...prev, message]);
  };

  const ensureHumanSocket = () => {
    if (humanSocketRef.current) {
      return humanSocketRef.current;
    }

    const socket = io(HANDOFF_SOCKET_URL, {
      transports: ["websocket"],
      withCredentials: true,
    });
    humanSocketRef.current = socket;
    setHumanChatStatus("connecting");

    socket.on("connect", () => {
      setHumanChatStatus("waiting");
      const sessionId = getHumanSessionId();
      socket.emit("handoff:start", {
        sessionId,
        userId: user?.id,
        userName: user?.fullName,
        userEmail: user?.email,
      });
    });

    socket.on("disconnect", () => {
      setHumanChatStatus("offline");
    });

    socket.on("handoff:status", (payload) => {
      if (payload?.status === "connected") {
        setHumanChatStatus("connected");
      }

      if (payload?.status === "waiting") {
        setHumanChatStatus("waiting");
      }

      if (payload?.status === "closed") {
        setHumanChatStatus("idle");
        setHumanChatOpen(false);
        setHumanChatClosing(false);
        setHumanChatMessages([]);
        setHumanChatInput("");
        humanSessionIdRef.current = null;
      }
    });

    socket.on("handoff:message", (payload) => {
      const isSelfEcho =
        payload?.source === "user" ||
        payload?.sender === "user" ||
        (payload?.sender &&
          user?.fullName &&
          payload.sender === user.fullName) ||
        (payload?.senderEmail &&
          user?.email &&
          payload.senderEmail === user.email);
      if (isSelfEcho) {
        return;
      }
      const text =
        typeof payload?.text === "string" ? payload.text.trim() : "";
      if (!text) {
        return;
      }
      appendHumanMessage({
        id: `human-${Date.now()}`,
        role: "human",
        content: text,
        createdAt: payload?.createdAt ?? new Date().toISOString(),
      });
    });

    return socket;
  };

  const handleHumanSupport = () => {
    if (!user) {
      return;
    }

    setHumanChatOpen(true);
    const socket = ensureHumanSocket();
    const sessionId = getHumanSessionId();

    if (socket.connected) {
      socket.emit("handoff:start", {
        sessionId,
        userId: user.id,
        userName: user.fullName,
        userEmail: user.email,
      });
    }
  };

  const handleHumanSend = () => {
    const trimmed = humanChatInput.trim();
    if (!trimmed) {
      return;
    }

    const sessionId = getHumanSessionId();
    const socket = ensureHumanSocket();
    appendHumanMessage({
      id: `user-${Date.now()}`,
      role: "user",
      content: trimmed,
      createdAt: new Date().toISOString(),
    });

    socket.emit("handoff:message", {
      sessionId,
      text: trimmed,
      sender: user?.fullName ?? "Cliente",
      senderEmail: user?.email,
    });

    setHumanChatInput("");
  };

  const closeHumanChat = () => {
    if (humanChatClosing) {
      return;
    }

    const sessionId = humanSessionIdRef.current;
    if (sessionId && humanSocketRef.current) {
      humanSocketRef.current.emit("handoff:close", {
        sessionId,
      });
    }

    setHumanChatClosing(true);
    appendHumanMessage({
      id: `system-${Date.now()}`,
      role: "system",
      content: "Conversación cerrada.",
      createdAt: new Date().toISOString(),
    });

    if (humanCloseTimerRef.current) {
      window.clearTimeout(humanCloseTimerRef.current);
    }

    humanCloseTimerRef.current = window.setTimeout(() => {
      if (humanSocketRef.current) {
        humanSocketRef.current.disconnect();
        humanSocketRef.current = null;
      }
      setHumanChatMessages([]);
      setHumanChatInput("");
      setHumanChatOpen(false);
      setHumanChatStatus("idle");
      setHumanChatClosing(false);
      humanSessionIdRef.current = null;
      humanCloseTimerRef.current = null;
    }, 900);
  };

  useEffect(() => {
    return () => {
      if (humanCloseTimerRef.current) {
        window.clearTimeout(humanCloseTimerRef.current);
      }
      if (humanSocketRef.current) {
        humanSocketRef.current.disconnect();
      }
    };
  }, []);

  return (
    <div className="dashboard-page">
      <div className="hero-card">
        <div>
          <h2>Hola, {user?.fullName}</h2>
          <p>
            {isAdmin
              ? "Estás dentro del backoffice embebido. Desde aquí podrás gestionar usuarios, sesiones y trazas del asistente."
              : "Bienvenido al portal de cliente. Desde aquí podrás iniciar pedidos y utilizar el asistente inteligente."}
          </p>
        </div>

        <div className="hero-card__actions">
          <Tippy content="Hablar con un humano">
            <span>
              <button
                className="secondary-button icon-button"
                onClick={handleHumanSupport}
                aria-label="Hablar con un humano"
              >
                <Headset size={16} />
              </button>
            </span>
          </Tippy>
          <button
            className="primary-button"
            onClick={() => navigate(isAdmin ? "/users" : "/assistant")}
          >
            {isAdmin ? (
              <>
                <Users size={16} />
                Ir a usuarios
              </>
            ) : (
              <>
                <MessageSquareText size={16} />
                Iniciar pedido con IA
              </>
            )}
          </button>
        </div>
      </div>

      <div className="stats-grid">
        {isAdmin ? (
          <>
            <article className="stat-card">
              <div className="stat-card__icon">
                <Users size={18} />
              </div>
              <div>
                <strong>2</strong>
                <p>Usuarios demo</p>
              </div>
            </article>

            <article className="stat-card">
              <div className="stat-card__icon">
                <ShieldCheck size={18} />
              </div>
              <div>
                <strong>3</strong>
                <p>Sesiones activas</p>
              </div>
            </article>

            <article className="stat-card">
              <div className="stat-card__icon">
                <Bot size={18} />
              </div>
              <div>
                <strong>12</strong>
                <p>Acciones LLM registradas</p>
              </div>
            </article>
          </>
        ) : (
          <>
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
          </>
        )}
      </div>

      <div className="content-grid">
        <section className="panel">
          <h3>{isAdmin ? "Accesos de backoffice" : "Accesos rápidos"}</h3>

          <div className="quick-actions">
            {isAdmin ? (
              <>
                <button
                  className="secondary-button"
                  onClick={() => navigate("/users")}
                >
                  Usuarios
                </button>
                <button
                  className="secondary-button"
                  onClick={() => navigate("/sessions")}
                >
                  Sesiones
                </button>
                <button
                  className="secondary-button"
                  onClick={() => navigate("/llm-actions")}
                >
                  Acciones LLM
                </button>
                <button
                  className="secondary-button"
                  onClick={() => navigate("/settings")}
                >
                  Configuración
                </button>
              </>
            ) : (
              <>
                <button
                  className="secondary-button"
                  onClick={() => navigate("/assistant")}
                >
                  Nuevo pedido
                </button>
                <button
                  className="secondary-button"
                  onClick={() => navigate("/orders")}
                >
                  Mis pedidos
                </button>
                <button
                  className="secondary-button"
                  onClick={() => navigate("/profile")}
                >
                  Mi perfil
                </button>
              </>
            )}
          </div>
        </section>

        <section className="panel">
          <h3>{isAdmin ? "Resumen técnico" : "Último pedido simulado"}</h3>

          {isAdmin ? (
            <div className="order-summary">
              <p>
                <strong>Auth:</strong> Cookies HttpOnly activas
              </p>
              <p>
                <strong>Sesiones:</strong> Persistidas en MySQL
              </p>
              <p>
                <strong>LLM:</strong> Provider desacoplado
              </p>
              <p>
                <strong>Widget:</strong> Overlay 1024x800 minimizable
              </p>
            </div>
          ) : (
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
          )}
        </section>
      </div>

      {humanChatOpen ? (
        <div className="human-chat__overlay">
          <div className="human-chat__panel">
            <div className="human-chat__header">
              <div>
                <h3>Chat con humano</h3>
                <p>{humanStatusLabel}</p>
              </div>
              <button
                className="secondary-button"
                onClick={closeHumanChat}
                disabled={humanChatClosing}
              >
                {humanChatClosing ? "Cerrando..." : "Volver al bot"}
              </button>
            </div>

            <div className="human-chat__messages">
              {humanChatMessages.length === 0 ? (
                <div className="human-chat__empty">
                  Envía tu primer mensaje y avisaremos a un humano.
                </div>
              ) : null}
              {humanChatMessages.map((message) => (
                <div
                  key={message.id}
                  className={`human-chat__message human-chat__message--${message.role}`}
                >
                  <div
                    className={`human-chat__bubble human-chat__bubble--${message.role}`}
                  >
                    <MarkdownText content={message.content} />
                  </div>
                </div>
              ))}
            </div>

            <div className="human-chat__input">
              <input
                type="text"
                placeholder="Escribe tu mensaje..."
                value={humanChatInput}
                onChange={(event) => setHumanChatInput(event.target.value)}
                onKeyDown={(event) => {
                  if (event.key === "Enter") {
                    event.preventDefault();
                    handleHumanSend();
                  }
                }}
                disabled={humanChatClosing}
              />
              <button
                className="primary-button icon-button"
                onClick={handleHumanSend}
                disabled={humanChatClosing || !humanChatInput.trim()}
                aria-label="Enviar al humano"
                title="Enviar al humano"
              >
                <SendHorizonal size={16} />
              </button>
            </div>
          </div>
        </div>
      ) : null}
    </div>
  );
};

export default DashboardPage;
