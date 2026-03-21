import { useEffect, useState } from "react";
import { SendHorizonal } from "lucide-react";
import { useAuthStore } from "@/modules/auth/auth.store";
import { useAssistantStore } from "@/modules/assistant/assistant.store";

const AssistantPage = () => {
  const user = useAuthStore((state) => state.user);

  const {
    messages,
    orderDraft,
    currentStep,
    validationSummary,
    topOption,
    isLoading,
    error,
    sessionId,
    startConversation,
    sendMessage,
    resetConversation,
    clearError,
  } = useAssistantStore();

  const [input, setInput] = useState("");

  useEffect(() => {
    if (!sessionId && user) {
      void startConversation({
        title: "Asistente de transporte",
        channel: "chat",
        language: "es",
        contextJson: {
          source: "assistant_page",
        },
      });
    }
  }, [sessionId, startConversation, user]);

  const handleSend = async () => {
    const trimmed = input.trim();

    if (!trimmed || !user || isLoading) {
      return;
    }

    setInput("");
    await sendMessage(trimmed);
  };

  const handleRestart = async () => {
    resetConversation();

    if (user) {
      await startConversation({
        title: "Asistente de transporte",
        channel: "chat",
        language: "es",
        contextJson: {
          source: "assistant_page_restart",
        },
      });
    }
  };

  return (
    <div className="assistant-page">
      <section className="panel assistant-panel">
        <div className="assistant-panel__header">
          <div>
            <h2>Asistente inteligente de pedidos</h2>
            <p>Wizard conversacional conectado al backend de orquestación.</p>
          </div>
        </div>

        {error ? (
          <div className="assistant-error">
            <span>{error}</span>
            <button className="secondary-button" onClick={clearError}>
              Cerrar
            </button>
          </div>
        ) : null}

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

          {isLoading ? (
            <div className="bubble assistant">
              <div className="bubble-role">Asistente IA</div>
              <div>Procesando solicitud...</div>
            </div>
          ) : null}
        </div>

        <div className="chat-input-row">
          <textarea
            value={input}
            onChange={(event) => setInput(event.target.value)}
            placeholder="Ej.: Necesito transportar 12000 litros de leche desde Málaga a Lleida"
            rows={3}
            disabled={isLoading}
          />

          <button
            className="primary-button"
            onClick={handleSend}
            disabled={isLoading || !input.trim()}
          >
            <SendHorizonal size={16} />
            Enviar
          </button>
        </div>
      </section>

      <aside className="panel side-panel">
        <button className="secondary-button" onClick={handleRestart}>
          Reiniciar conversación
        </button>

        <h3>Pedido en curso</h3>

        {/* <div className="draft-grid">
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
          <div>
            <span>Siguiente paso</span>
            <strong>{currentStep?.wizardStep?.label ?? "Completado"}</strong>
          </div>
        </div> */}

        {validationSummary ? (
          <div className="proposal-card">
            <h4>Validación</h4>
            <p>
              <strong>Total reglas:</strong> {validationSummary.total}
            </p>
            <p>
              <strong>Correctas:</strong> {validationSummary.passed}
            </p>
            <p>
              <strong>Fallidas:</strong> {validationSummary.failed}
            </p>
            <p>
              <strong>Warnings:</strong> {validationSummary.warnings}
            </p>
          </div>
        ) : null}

        {topOption ? (
          <div className="proposal-card">
            <h4>Opción recomendada</h4>
            <p>
              <strong>Vehículo:</strong>{" "}
              {orderDraft.proposedOption?.vehicle ?? "Pendiente"}
            </p>
            <p>
              <strong>Salida:</strong>{" "}
              {orderDraft.proposedOption?.departure ?? "Pendiente"}
            </p>
            <p>
              <strong>Llegada estimada:</strong>{" "}
              {orderDraft.proposedOption?.arrival ?? "Pendiente"}
            </p>
            <p>
              <strong>Coste estimado:</strong>{" "}
              {topOption.estimatedCost ?? "N/D"} €
            </p>
            <p>
              <strong>Tránsito estimado:</strong>{" "}
              {topOption.estimatedTransitHours ?? "N/D"} h
            </p>
            <p>
              <strong>Comentario:</strong>{" "}
              {orderDraft.proposedOption?.note ?? "Sin comentario"}
            </p>
          </div>
        ) : null}
      </aside>
    </div>
  );
};

export default AssistantPage;
