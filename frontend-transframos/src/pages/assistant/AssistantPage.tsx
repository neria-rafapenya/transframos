import { useMemo, useState } from "react";
import { SendHorizonal } from "lucide-react";
import { useAuthStore } from "@/modules/auth/auth.store";
import {
  buildAssistantReply,
  getInitialAssistantMessages,
} from "@/modules/assistant/assistant.mock";
import { useAssistantStore } from "@/modules/assistant/assistant.store";

const AssistantPage = () => {
  const user = useAuthStore((state) => state.user);
  const {
    messages,
    orderDraft,
    initializeConversation,
    addUserMessage,
    addAssistantMessage,
    setOrderDraft,
    resetConversation,
  } = useAssistantStore();

  const [input, setInput] = useState("");

  useMemo(() => {
    if (messages.length === 0 && user) {
      initializeConversation(getInitialAssistantMessages(user.fullName));
    }
  }, [initializeConversation, messages.length, user]);

  const handleSend = () => {
    const trimmed = input.trim();

    if (!trimmed || !user) {
      return;
    }

    addUserMessage(trimmed);

    const result = buildAssistantReply({
      userMessage: trimmed,
      currentDraft: orderDraft,
      user,
    });

    addAssistantMessage(result.message);
    setOrderDraft(result.nextDraft);
    setInput("");
  };

  const handleRestart = () => {
    resetConversation();
    if (user) {
      initializeConversation(getInitialAssistantMessages(user.fullName));
    }
  };

  return (
    <div className="assistant-page">
      <section className="panel assistant-panel">
        <div className="assistant-panel__header">
          <div>
            <h2>Asistente inteligente de pedidos</h2>
            <p>
              Inicia un nuevo pedido en lenguaje natural. La demo simula
              validación de disponibilidad y propuesta alternativa.
            </p>
          </div>

          <button className="secondary-button" onClick={handleRestart}>
            Reiniciar conversación
          </button>
        </div>

        <div className="chat-window">
          {messages.map((message) => (
            <div
              key={message.id}
              className={
                message.role === "assistant"
                  ? "bubble assistant"
                  : "bubble user"
              }
            >
              <div className="bubble-role">
                {message.role === "assistant" ? "Asistente IA" : user?.fullName}
              </div>
              <div>{message.content}</div>
            </div>
          ))}
        </div>

        <div className="chat-input-row">
          <textarea
            value={input}
            onChange={(event) => setInput(event.target.value)}
            placeholder="Ej.: Necesito transportar 1400 litros de zumo"
            rows={3}
          />

          <button className="primary-button" onClick={handleSend}>
            <SendHorizonal size={16} />
            Enviar
          </button>
        </div>
      </section>

      <aside className="panel side-panel">
        <h3>Pedido en curso</h3>

        <div className="draft-grid">
          <div>
            <span>Producto</span>
            <strong>{orderDraft.product ?? "Pendiente"}</strong>
          </div>
          <div>
            <span>Cantidad</span>
            <strong>
              {orderDraft.volume
                ? `${orderDraft.volume} ${orderDraft.unit ?? ""}`
                : "Pendiente"}
            </strong>
          </div>
          <div>
            <span>Origen</span>
            <strong>{orderDraft.origin ?? "Pendiente"}</strong>
          </div>
          <div>
            <span>Destino</span>
            <strong>{orderDraft.destination ?? "Pendiente"}</strong>
          </div>
          <div>
            <span>Fecha solicitada</span>
            <strong>{orderDraft.requestedDate ?? "Pendiente"}</strong>
          </div>
          <div>
            <span>Límite de entrega</span>
            <strong>{orderDraft.deliveryDeadline ?? "Pendiente"}</strong>
          </div>
          <div>
            <span>Estado</span>
            <strong>{orderDraft.status}</strong>
          </div>
        </div>

        {orderDraft.proposedOption ? (
          <div className="proposal-card">
            <h4>Alternativa propuesta</h4>
            <p>
              <strong>Vehículo:</strong> {orderDraft.proposedOption.vehicle}
            </p>
            <p>
              <strong>Salida:</strong> {orderDraft.proposedOption.departure}
            </p>
            <p>
              <strong>Llegada estimada:</strong>{" "}
              {orderDraft.proposedOption.arrival}
            </p>
            <p>
              <strong>Comentario:</strong> {orderDraft.proposedOption.note}
            </p>
          </div>
        ) : null}
      </aside>
    </div>
  );
};

export default AssistantPage;
