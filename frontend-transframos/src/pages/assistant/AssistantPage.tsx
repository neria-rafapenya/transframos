import { useEffect, useRef, useState } from "react";
import { ArrowUp, Headset, SendHorizonal } from "lucide-react";
import { useNavigate } from "react-router-dom";
import { io, type Socket } from "socket.io-client";
import { useAuthStore } from "@/modules/auth/auth.store";
import { useAssistantStore } from "@/modules/assistant/assistant.store";
import RoutePreviewMap from "./RoutePreviewMap";
import SpinnerDots from "@/components/shared/SpinnerDots";
import Tippy from "@tippyjs/react";
import MarkdownText from "@/components/shared/MarkdownText";
import CopyIcon from "@/components/icons/CopyIcon";
import AudioPlayIcon from "@/components/icons/AudioPlayIcon";
import AudioMutedIcon from "@/components/icons/AudioMutedIcon";
import {
  ASSISTANT_CORRECTION_PLACEHOLDERS,
  ASSISTANT_PLACEHOLDERS,
  pickRandomPlaceholder,
} from "@/modules/assistant/assistant.placeholders";

type HumanChatMessage = {
  id: string;
  role: "user" | "human" | "system";
  content: string;
  createdAt: string;
};

const HANDOFF_SOCKET_URL =
  import.meta.env.VITE_HANDOFF_SOCKET_URL ?? "http://localhost:5000/handoff";

const AssistantPage = () => {
  const getDefaultPlaceholder = () =>
    pickRandomPlaceholder(ASSISTANT_PLACEHOLDERS);
  const getCorrectionPlaceholder = () =>
    pickRandomPlaceholder(ASSISTANT_CORRECTION_PLACEHOLDERS);
  const user = useAuthStore((state) => state.user);
  const navigate = useNavigate();

  const {
    messages,
    wizard,
    quoteRequest,
    orderDraft,
    topOption,
    isLoading,
    error,
    sessionId,
    validationSummary,
    routePreview,
    startConversation,
    sendMessage,
    resetConversation,
    clearError,
  } = useAssistantStore();

  const [input, setInput] = useState("");
  const [inputPlaceholder, setInputPlaceholder] = useState(() =>
    getDefaultPlaceholder(),
  );
  const chatScrollRef = useRef<HTMLDivElement | null>(null);
  const chatEndRef = useRef<HTMLDivElement | null>(null);
  const [isAtBottom, setIsAtBottom] = useState(true);
  const shouldAutoScrollRef = useRef(true);
  const textareaRef = useRef<HTMLTextAreaElement | null>(null);
  const [tramitarPending, setTramitarPending] = useState(false);
  const [tramitarMarker, setTramitarMarker] = useState<number | null>(null);
  const [showTramitarModal, setShowTramitarModal] = useState(false);
  const [showTramitarSuccess, setShowTramitarSuccess] = useState(false);
  const [tramitarForm, setTramitarForm] = useState({
    originAddress: "",
    destinationAddress: "",
    contactName: "",
    contactPhone: "",
  });
  const [tramitarErrors, setTramitarErrors] = useState<{
    originAddress?: string;
    destinationAddress?: string;
    contactName?: string;
    contactPhone?: string;
  }>({});
  const [humanChatOpen, setHumanChatOpen] = useState(false);
  const [humanChatStatus, setHumanChatStatus] = useState<
    "idle" | "connecting" | "waiting" | "connected" | "offline"
  >("idle");
  const [humanChatClosing, setHumanChatClosing] = useState(false);
  const [humanChatInput, setHumanChatInput] = useState("");
  const [humanChatMessages, setHumanChatMessages] = useState<
    HumanChatMessage[]
  >([]);
  const humanSocketRef = useRef<Socket | null>(null);
  const humanCloseTimerRef = useRef<number | null>(null);
  const [copyFeedbackId, setCopyFeedbackId] = useState<string | null>(null);
  const [copyToastVisible, setCopyToastVisible] = useState(false);
  const copyToastTimerRef = useRef<number | null>(null);
  const [speakingId, setSpeakingId] = useState<string | null>(null);
  const speechRef = useRef<SpeechSynthesisUtterance | null>(null);

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

  useEffect(() => {
    return () => {
      humanSocketRef.current?.disconnect();
      if (humanCloseTimerRef.current) {
        window.clearTimeout(humanCloseTimerRef.current);
      }
    };
  }, []);

  useEffect(() => {
    const element = textareaRef.current;
    if (!element) {
      return;
    }

    element.style.height = "auto";
    const nextHeight = Math.min(element.scrollHeight, 200);
    element.style.height = `${nextHeight}px`;
    element.style.overflowY = element.scrollHeight > 200 ? "auto" : "hidden";
  }, [input]);

  useEffect(() => {
    return () => {
      stopSpeech();
      if (copyToastTimerRef.current) {
        window.clearTimeout(copyToastTimerRef.current);
      }
    };
  }, []);

  useEffect(() => {
    const element = chatScrollRef.current;
    if (!element) {
      return;
    }

    const handleScroll = () => {
      const threshold = 120;
      const atBottom =
        element.scrollTop + element.clientHeight >=
        element.scrollHeight - threshold;
      setIsAtBottom(atBottom);
    };

    handleScroll();
    element.addEventListener("scroll", handleScroll);

    return () => {
      element.removeEventListener("scroll", handleScroll);
    };
  }, []);

  useEffect(() => {
    if (!chatEndRef.current) {
      return;
    }

    if (isAtBottom || shouldAutoScrollRef.current) {
      chatEndRef.current.scrollIntoView({ behavior: "smooth", block: "end" });
      shouldAutoScrollRef.current = false;
    }
  }, [messages, isLoading, isAtBottom]);

  const getWizardRawText = (stepCode: string): string | null => {
    const step = wizard.find((item) => item.stepCode === stepCode);
    const rawText = step?.valueJson?.rawText;
    return typeof rawText === "string" ? rawText : null;
  };

  const getReasoningString = (key: string): string | null => {
    const value = topOption?.reasoningJson?.[key];
    if (typeof value !== "string") {
      return null;
    }
    const trimmed = value.trim();
    return trimmed.length > 0 ? trimmed : null;
  };

  const getReasoningNumber = (key: string): number | null => {
    const value = topOption?.reasoningJson?.[key];
    return typeof value === "number" && Number.isFinite(value) ? value : null;
  };

  const getReasoningBoolean = (key: string): boolean | null => {
    const value = topOption?.reasoningJson?.[key];
    return typeof value === "boolean" ? value : null;
  };

  const openTramitarModal = () => {
    if (isLoading) {
      return;
    }

    setTramitarErrors({});
    setTramitarForm({
      originAddress: getWizardRawText("origin_address") ?? "",
      destinationAddress: getWizardRawText("destination_address") ?? "",
      contactName:
        getWizardRawText("origin_contact_name") ??
        getWizardRawText("destination_contact_name") ??
        "",
      contactPhone:
        getWizardRawText("origin_contact_phone") ??
        getWizardRawText("destination_contact_phone") ??
        "",
    });
    setShowTramitarModal(true);
  };

  const handleTramitarSubmit = async () => {
    if (isLoading) {
      return;
    }

    const nextErrors: typeof tramitarErrors = {};
    if (!tramitarForm.originAddress.trim()) {
      nextErrors.originAddress = "Indica la dirección de recogida.";
    }
    if (!tramitarForm.destinationAddress.trim()) {
      nextErrors.destinationAddress = "Indica la dirección de entrega.";
    }
    if (!tramitarForm.contactName.trim()) {
      nextErrors.contactName = "Indica la persona de contacto.";
    }
    if (!tramitarForm.contactPhone.trim()) {
      nextErrors.contactPhone = "Indica el teléfono de contacto.";
    }

    setTramitarErrors(nextErrors);
    if (Object.keys(nextErrors).length > 0) {
      return;
    }

    setShowTramitarModal(false);
    setTramitarPending(true);
    setTramitarMarker(messages.length);

    const origin = orderDraft.origin ?? "origen pendiente";
    const destination = orderDraft.destination ?? "destino pendiente";
    const message = [
      "Tramitar pedido.",
      `Origen: ${origin}. Dirección de recogida: ${tramitarForm.originAddress}.`,
      `Destino: ${destination}. Dirección de entrega: ${tramitarForm.destinationAddress}.`,
      `Contacto origen: ${tramitarForm.contactName}. Teléfono origen: ${tramitarForm.contactPhone}.`,
      `Contacto destino: ${tramitarForm.contactName}. Teléfono destino: ${tramitarForm.contactPhone}.`,
    ].join(" ");

    await sendMessage(message, { forceTramitar: true });
  };

  useEffect(() => {
    if (!tramitarPending || tramitarMarker === null) {
      return;
    }

    const reversedIndex = [...messages]
      .reverse()
      .findIndex((message) => message.role === "assistant");
    if (reversedIndex === -1) {
      return;
    }

    const messageIndex = messages.length - 1 - reversedIndex;
    if (messageIndex <= tramitarMarker) {
      return;
    }

    const content = messages[messageIndex]?.content?.toLowerCase() ?? "";
    const success =
      content.includes("pedido tramitado") ||
      content.includes("ya estaba tramitado");

    setTramitarPending(false);
    setTramitarMarker(null);

    if (success) {
      setShowTramitarSuccess(true);
      window.setTimeout(() => {
        setShowTramitarSuccess(false);
        resetConversation();
        navigate("/orders");
      }, 1200);
    }
  }, [messages, navigate, resetConversation, tramitarMarker, tramitarPending]);

  const suggestedRouteCode = getReasoningString("llmSuggestedRouteCode");
  const suggestedRouteConfidence = getReasoningNumber(
    "llmSuggestedRouteConfidence",
  );
  const suggestedRouteRationale = getReasoningString(
    "llmSuggestedRouteRationale",
  );
  const suggestedRouteAccepted = getReasoningBoolean(
    "llmSuggestedRouteAccepted",
  );
  const suggestedRouteMinConfidence = getReasoningNumber(
    "llmSuggestedRouteMinConfidence",
  );

  const lastAssistantMessage = [...messages]
    .reverse()
    .find((message) => message.role === "assistant")?.content;
  const hasSummaryMessage =
    typeof lastAssistantMessage === "string" &&
    lastAssistantMessage.trim().startsWith("Resumen:");

  const parseSummaryMessage = (summaryText: string | null) => {
    if (!summaryText) {
      return null;
    }

    const normalized = summaryText.replace(/^Resumen:\s*/i, "").trim();
    const match = normalized.match(
      /Se realizará un transporte de (.+?) de (.+?) con recogida (.+?) en (.+?) Entrega (.+?) en (.+)/,
    );

    if (!match) {
      return null;
    }

    const stripDot = (value: string) => value.trim().replace(/[.]$/, "");

    return {
      quantity: match[1].trim(),
      product: match[2].trim(),
      pickup: match[3].trim(),
      origin: stripDot(match[4]),
      delivery: match[5].trim(),
      destination: stripDot(match[6]),
    };
  };

  const summaryFromMessage =
    typeof lastAssistantMessage === "string"
      ? parseSummaryMessage(lastAssistantMessage)
      : null;

  const canTramitar =
    orderDraft.status === "ready" &&
    orderDraft.missingClientData.length === 0 &&
    !(validationSummary?.failed && validationSummary.failed > 0);
  const showSummaryPanel = hasSummaryMessage || canTramitar;

  const humanStatusLabel = {
    idle: "Sin iniciar",
    connecting: "Conectando...",
    waiting: "Esperando a un humano...",
    connected: "En conversación",
    offline: "Desconectado",
  }[humanChatStatus];

  const formatDateDisplay = (value: string | null | undefined) => {
    if (!value) {
      return null;
    }

    const trimmed = value.trim();
    if (!trimmed) {
      return null;
    }

    const dateOnlyMatch = trimmed.match(/^(\d{4})-(\d{2})-(\d{2})$/);
    if (dateOnlyMatch) {
      return `${dateOnlyMatch[3]}/${dateOnlyMatch[2]}/${dateOnlyMatch[1]}`;
    }

    const dateTimeMatch = trimmed.match(
      /^(\d{4})-(\d{2})-(\d{2})[T ](\d{2}):(\d{2})/,
    );
    if (dateTimeMatch) {
      return `${dateTimeMatch[3]}/${dateTimeMatch[2]}/${dateTimeMatch[1]} ${dateTimeMatch[4]}:${dateTimeMatch[5]}`;
    }

    const parsed = new Date(trimmed);
    if (!Number.isNaN(parsed.getTime())) {
      return new Intl.DateTimeFormat("es-ES", {
        day: "2-digit",
        month: "2-digit",
        year: "numeric",
        hour: "2-digit",
        minute: "2-digit",
      }).format(parsed);
    }

    return trimmed;
  };

  const getFirstText = (
    candidates: Array<string | null | undefined>,
    fallback = "—",
  ) => {
    for (const candidate of candidates) {
      if (typeof candidate !== "string") {
        continue;
      }
      const trimmed = candidate.trim();
      if (trimmed.length > 0) {
        return trimmed;
      }
    }
    return fallback;
  };

  const modalProduct = getFirstText([
    orderDraft.product,
    getWizardRawText("product"),
  ]);

  const modalQuantity = getFirstText([
    typeof orderDraft.volume === "number"
      ? `${orderDraft.volume} ${orderDraft.unit ?? "L"}`
      : null,
    quoteRequest?.quantityValue
      ? `${quoteRequest.quantityValue} ${quoteRequest.quantityUnit ?? "L"}`
      : null,
    getWizardRawText("quantity"),
  ]);

  const modalOrigin = getFirstText([
    orderDraft.origin,
    getWizardRawText("origin"),
  ]);

  const modalDestination = getFirstText([
    orderDraft.destination,
    getWizardRawText("destination"),
  ]);

  const modalPickup =
    formatDateDisplay(
      orderDraft.requestedDate ??
        quoteRequest?.requestedPickupAt ??
        getWizardRawText("requested_date"),
    ) ?? "—";

  const modalDelivery =
    formatDateDisplay(
      orderDraft.deliveryDeadline ??
        quoteRequest?.deliveryDeadlineAt ??
        getWizardRawText("delivery_deadline"),
    ) ?? "—";

  const buildSummary = () => {
    if (!topOption) {
      return null;
    }

    const product = orderDraft.product ?? "producto";
    const categoryName =
      getReasoningString("productCategoryName") ??
      getReasoningString("productCategoryCode");
    const productLabel = categoryName
      ? `${product} (${categoryName})`
      : product;
    const quantity =
      typeof orderDraft.volume === "number"
        ? `${orderDraft.volume} ${orderDraft.unit ?? "L"}`
        : "cantidad pendiente";
    const pickup = formatDateDisplay(orderDraft.requestedDate) ?? "pendiente";
    const delivery =
      formatDateDisplay(orderDraft.deliveryDeadline) ?? "pendiente";
    const origin = orderDraft.origin ?? "origen pendiente";
    const destination = orderDraft.destination ?? "destino pendiente";

    const originAddress = getWizardRawText("origin_address");
    const originContactName = getWizardRawText("origin_contact_name");
    const originContactPhone = getWizardRawText("origin_contact_phone");
    const destinationAddress = getWizardRawText("destination_address");
    const destinationContactName = getWizardRawText("destination_contact_name");
    const destinationContactPhone = getWizardRawText(
      "destination_contact_phone",
    );

    const originContact =
      originContactName || originContactPhone
        ? ` Responsable: ${originContactName ?? "sin nombre"}${
            originContactPhone ? ` (${originContactPhone})` : ""
          }.`
        : "";
    const destinationContact =
      destinationContactName || destinationContactPhone
        ? ` Responsable: ${destinationContactName ?? "sin nombre"}${
            destinationContactPhone ? ` (${destinationContactPhone})` : ""
          }.`
        : "";

    const originText = `${origin}${
      originAddress ? ` (${originAddress})` : ""
    }.${originContact}`;
    const destinationText = `${destination}${
      destinationAddress ? ` (${destinationAddress})` : ""
    }.${destinationContact}`;

    return `Se realizará un transporte de ${quantity} de ${productLabel} con recogida ${pickup} en ${originText} Entrega ${delivery} en ${destinationText}`;
  };

  const handleSend = async () => {
    const trimmed = input.trim();

    if (!trimmed || !user || isLoading) {
      return;
    }

    setInput("");
    setInputPlaceholder(getDefaultPlaceholder());
    shouldAutoScrollRef.current = true;
    await sendMessage(trimmed);
  };

  const appendHumanMessage = (message: HumanChatMessage) => {
    setHumanChatMessages((prev) => [...prev, message]);
  };

  const ensureHumanSocket = () => {
    if (humanSocketRef.current) {
      return humanSocketRef.current;
    }

    const forcePolling =
      import.meta.env.VITE_HANDOFF_FORCE_POLLING === "true";
    const socket = io(HANDOFF_SOCKET_URL, {
      transports: forcePolling ? ["polling"] : ["polling", "websocket"],
      withCredentials: true,
    });
    humanSocketRef.current = socket;
    setHumanChatStatus("connecting");

    socket.on("connect", () => {
      setHumanChatStatus("waiting");
      if (sessionId) {
        socket.emit("handoff:start", {
          sessionId: String(sessionId),
          userId: user?.id,
          userName: user?.fullName,
          userEmail: user?.email,
        });
      }
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

    if (socket.connected && sessionId) {
      socket.emit("handoff:start", {
        sessionId: String(sessionId),
        userId: user.id,
        userName: user.fullName,
        userEmail: user.email,
      });
    }
  };

  const handleHumanSend = () => {
    const trimmed = humanChatInput.trim();
    if (!trimmed || !sessionId) {
      return;
    }

    const socket = ensureHumanSocket();
    appendHumanMessage({
      id: `user-${Date.now()}`,
      role: "user",
      content: trimmed,
      createdAt: new Date().toISOString(),
    });

    socket.emit("handoff:message", {
      sessionId: String(sessionId),
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

    if (sessionId && humanSocketRef.current) {
      humanSocketRef.current.emit("handoff:close", {
        sessionId: String(sessionId),
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
      humanCloseTimerRef.current = null;
    }, 900);
  };

  const handleRestart = async () => {
    resetConversation();
    setInput("");
    setInputPlaceholder(getDefaultPlaceholder());

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

  const copyToClipboard = async (text: string, id: string) => {
    try {
      if (navigator?.clipboard?.writeText) {
        await navigator.clipboard.writeText(text);
      } else {
        const textarea = document.createElement("textarea");
        textarea.value = text;
        textarea.style.position = "fixed";
        textarea.style.top = "-1000px";
        textarea.style.left = "-1000px";
        document.body.appendChild(textarea);
        textarea.focus();
        textarea.select();
        document.execCommand("copy");
        document.body.removeChild(textarea);
      }
      setCopyFeedbackId(id);
      window.setTimeout(() => {
        setCopyFeedbackId((prev) => (prev === id ? null : prev));
      }, 1400);
      setCopyToastVisible(true);
      if (copyToastTimerRef.current) {
        window.clearTimeout(copyToastTimerRef.current);
      }
      copyToastTimerRef.current = window.setTimeout(() => {
        setCopyToastVisible(false);
        copyToastTimerRef.current = null;
      }, 1600);
    } catch {
      // noop
    }
  };

  const stripMarkdownForSpeech = (text: string) => {
    return text
      .replace(/```[\s\S]*?```/g, " ")
      .replace(/`([^`]+)`/g, "$1")
      .replace(/!\[([^\]]*)\]\([^)]+\)/g, "$1")
      .replace(/\[([^\]]+)\]\([^)]+\)/g, "$1")
      .replace(/[*_~>#]+/g, "")
      .replace(/^\s*[-*+]\s+/gm, "")
      .replace(/^\s*\d+\.\s+/gm, "")
      .replace(/\s+/g, " ")
      .trim();
  };

  const stopSpeech = () => {
    if (typeof window === "undefined" || !("speechSynthesis" in window)) {
      return;
    }

    window.speechSynthesis.cancel();
    speechRef.current = null;
    setSpeakingId(null);
  };

  const speakMessage = (text: string, id: string) => {
    if (speakingId === id) {
      stopSpeech();
      return;
    }

    if (typeof window === "undefined" || !("speechSynthesis" in window)) {
      return;
    }

    stopSpeech();

    const utterance = new SpeechSynthesisUtterance(
      stripMarkdownForSpeech(text),
    );
    utterance.lang = "es-ES";
    utterance.onend = () => {
      setSpeakingId((current) => (current === id ? null : current));
    };
    utterance.onerror = () => {
      setSpeakingId((current) => (current === id ? null : current));
    };

    speechRef.current = utterance;
    setSpeakingId(id);
    window.speechSynthesis.speak(utterance);
  };

  return (
    <div className="assistant-page">
      <section className="panel assistant-panel">
        <div className="assistant-panel__header">
          <div>
            <h2>Asistente inteligente de pedidos</h2>
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
          <div className="chat-window__scroll" ref={chatScrollRef}>
            {messages.length === 0 && !isLoading ? (
              <div className="bubble-group bubble-group--assistant">
                <div className="bubble assistant">
                  <div className="bubble-role">Asistente IA</div>
                  <MarkdownText content="Bienvenido. ¿En que puedo ayudarte con tu solicitud de transporte?" />
                </div>
                <div className="bubble-tools">
                  <Tippy
                    content={
                      speakingId === "welcome-audio"
                        ? "Detener audio"
                        : "Escuchar mensaje"
                    }
                  >
                    <span>
                      <button
                        className="bubble-audio"
                        onClick={() =>
                          speakMessage(
                            "Bienvenido. ¿En que puedo ayudarte con tu solicitud de transporte?",
                            "welcome-audio",
                          )
                        }
                        aria-label="Escuchar mensaje"
                      >
                        {speakingId === "welcome-audio" ? (
                          <AudioMutedIcon />
                        ) : (
                          <AudioPlayIcon />
                        )}
                      </button>
                    </span>
                  </Tippy>
                  <Tippy
                    content={copyFeedbackId === "welcome" ? "Copiado" : "Copiar"}
                  >
                    <span>
                      <button
                        className="bubble-copy"
                        onClick={() =>
                          copyToClipboard(
                            "Bienvenido. ¿En que puedo ayudarte con tu solicitud de transporte?",
                            "welcome",
                          )
                        }
                        aria-label="Copiar mensaje"
                      >
                        <CopyIcon />
                      </button>
                    </span>
                  </Tippy>
                </div>
              </div>
            ) : null}

            {messages.map((message) => (
              <div
                key={message.id}
                className={`bubble-group bubble-group--${
                  message.role === "assistant" ? "assistant" : "user"
                }`}
              >
                <div
                  className={
                    message.role === "assistant"
                      ? "bubble assistant"
                      : "bubble user"
                  }
                >
                  <div className="bubble-role">
                    {message.role === "assistant"
                      ? "Asistente IA"
                      : user?.fullName}
                  </div>
                  <MarkdownText content={message.content} />
                </div>
                <div className="bubble-tools">
                  <Tippy
                    content={
                      speakingId === `audio-${message.id}`
                        ? "Detener audio"
                        : "Escuchar mensaje"
                    }
                  >
                    <span>
                      <button
                        className="bubble-audio"
                        onClick={() =>
                          speakMessage(message.content, `audio-${message.id}`)
                        }
                        aria-label="Escuchar mensaje"
                      >
                        {speakingId === `audio-${message.id}` ? (
                          <AudioMutedIcon />
                        ) : (
                          <AudioPlayIcon />
                        )}
                      </button>
                    </span>
                  </Tippy>
                  <Tippy
                    content={
                      copyFeedbackId === `msg-${message.id}`
                        ? "Copiado"
                        : "Copiar"
                    }
                  >
                    <span>
                      <button
                        className="bubble-copy"
                        onClick={() =>
                          copyToClipboard(message.content, `msg-${message.id}`)
                        }
                        aria-label="Copiar mensaje"
                      >
                        <CopyIcon />
                      </button>
                    </span>
                  </Tippy>
                </div>
              </div>
            ))}

            {isLoading ? (
              <div className="bubble assistant">
                <div className="bubble-role">Asistente IA</div>
                <div className="assistant-spinner">
                  <SpinnerDots size={26} />
                </div>
              </div>
            ) : null}

            <div ref={chatEndRef} />
          </div>

          {!isAtBottom ? (
            <button
              className="chat-scroll-button"
              onClick={() => {
                chatEndRef.current?.scrollIntoView({
                  behavior: "smooth",
                  block: "end",
                });
              }}
              aria-label="Ver últimos mensajes"
              title="Ver últimos mensajes"
            >
              <ArrowUp size={16} />
            </button>
          ) : null}
        </div>

        <div className="chat-input-row">
          <textarea
            ref={textareaRef}
            value={input}
            onChange={(event) => setInput(event.target.value)}
            onKeyDown={(event) => {
              if (
                event.key === "Enter" &&
                !event.ctrlKey &&
                !event.shiftKey &&
                !event.metaKey
              ) {
                event.preventDefault();
                void handleSend();
              }
            }}
            placeholder={inputPlaceholder}
            rows={1}
            disabled={isLoading}
            onBlur={() => {
              if (!input.trim()) {
                setInputPlaceholder(getDefaultPlaceholder());
              }
            }}
          />

          <div className="chat-input-actions">
            <Tippy content="Hablar con un humano">
              <span>
                <button
                  className="secondary-button icon-button"
                  onClick={handleHumanSupport}
                  disabled={isLoading}
                  aria-label="Hablar con un humano"
                >
                  <Headset size={16} />
                </button>
              </span>
            </Tippy>
            <button
              className="primary-button icon-button"
              onClick={handleSend}
              disabled={isLoading || !input.trim()}
              aria-label="Enviar"
              title="Enviar"
            >
              <SendHorizonal size={16} />
            </button>
          </div>
        </div>
      </section>

      <aside className="panel side-panel">
        <button className="secondary-button" onClick={handleRestart}>
          Reiniciar conversación
        </button>

        {showSummaryPanel ? (
          <div className="proposal-card">
            {(() => {
              const items = [
                {
                  label: "Producto",
                  value: summaryFromMessage?.product ?? orderDraft.product,
                },
                {
                  label: "Cantidad",
                  value:
                    summaryFromMessage?.quantity ??
                    (typeof orderDraft.volume === "number"
                      ? `${orderDraft.volume} ${orderDraft.unit ?? "L"}`
                      : null),
                },
                {
                  label: "Origen",
                  value: summaryFromMessage?.origin ?? orderDraft.origin,
                },
                {
                  label: "Destino",
                  value:
                    summaryFromMessage?.destination ?? orderDraft.destination,
                },
                {
                  label: "Recogida",
                  value:
                    summaryFromMessage?.pickup ??
                    formatDateDisplay(orderDraft.requestedDate),
                },
                {
                  label: "Límite",
                  value:
                    summaryFromMessage?.delivery ??
                    formatDateDisplay(orderDraft.deliveryDeadline),
                },
              ].filter((item) => item.value);

              if (items.length === 0) {
                return summaryFromMessage ? (
                  <p>{lastAssistantMessage}</p>
                ) : null;
              }

              return (
                <ul className="summary-list">
                  {items.map((item) => (
                    <li key={item.label}>
                      <strong>{item.label}:</strong> {item.value}
                    </li>
                  ))}
                </ul>
              );
            })()}

            <RoutePreviewMap
              routePreview={routePreview}
              redrawKey={messages.length}
            />

            <div className="summary-actions">
              <button
                className="primary-button full-width"
                onClick={openTramitarModal}
                disabled={isLoading || tramitarPending}
              >
                Tramitar pedido
              </button>
              <button
                className="secondary-button full-width"
                onClick={() => {
                  setInputPlaceholder(getCorrectionPlaceholder());
                  textareaRef.current?.focus();
                }}
                disabled={isLoading}
              >
                Corregir datos
              </button>
            </div>
          </div>
        ) : null}

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
            <strong>
              {formatDateDisplay(orderDraft.requestedDate) ?? "Pendiente"}
            </strong>
          </div>
          <div>
            <span>Límite de entrega</span>
            <strong>
              {formatDateDisplay(orderDraft.deliveryDeadline) ?? "Pendiente"}
            </strong>
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

        {false && validationSummary ? (
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

        {topOption?.isFeasible ? (
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
              {typeof topOption.estimatedCost === "number"
                ? topOption.estimatedCost
                : "Pendiente"}{" "}
              €
            </p>
            {typeof topOption.estimatedTransitHours === "number" ? (
              <p>
                <strong>Tránsito estimado:</strong>{" "}
                {topOption.estimatedTransitHours} h
              </p>
            ) : null}
            {suggestedRouteCode ? (
              <p>
                <strong>Ruta sugerida IA:</strong> {suggestedRouteCode}
                {typeof suggestedRouteConfidence === "number"
                  ? ` (confianza ${suggestedRouteConfidence.toFixed(2)})`
                  : ""}
                {typeof suggestedRouteMinConfidence === "number"
                  ? ` · mínimo ${suggestedRouteMinConfidence.toFixed(2)}`
                  : ""}
                {typeof suggestedRouteAccepted === "boolean"
                  ? suggestedRouteAccepted
                    ? " · aplicada"
                    : " · no aplicada"
                  : ""}
              </p>
            ) : null}
            {suggestedRouteRationale ? (
              <p>
                <strong>Motivo IA:</strong> {suggestedRouteRationale}
              </p>
            ) : null}
          </div>
        ) : null}
      </aside>

      {showTramitarModal ? (
        <div className="tramitar-modal__overlay">
          <div className="tramitar-modal">
            <div className="tramitar-modal__header">
              <div>
                <h3>Tramitar pedido</h3>
                <p>Revisa los datos y añade la información de contacto.</p>
              </div>
              <button
                className="secondary-button"
                onClick={() => setShowTramitarModal(false)}
                disabled={isLoading}
              >
                Cancelar
              </button>
            </div>

            <div className="tramitar-modal__summary">
              <div>
                <span>Producto</span>
                <strong>{modalProduct}</strong>
              </div>
              <div>
                <span>Cantidad</span>
                <strong>{modalQuantity}</strong>
              </div>
              <div>
                <span>Origen</span>
                <strong>{modalOrigin}</strong>
              </div>
              <div>
                <span>Destino</span>
                <strong>{modalDestination}</strong>
              </div>
              <div>
                <span>Recogida</span>
                <strong>{modalPickup}</strong>
              </div>
              <div>
                <span>Límite</span>
                <strong>{modalDelivery}</strong>
              </div>
            </div>

            <div className="tramitar-modal__form">
              <label>
                Dirección exacta de recogida
                <input
                  type="text"
                  value={tramitarForm.originAddress}
                  onChange={(event) =>
                    setTramitarForm((prev) => ({
                      ...prev,
                      originAddress: event.target.value,
                    }))
                  }
                  placeholder="Ej.: Calle Mayor 12, 25005 Lleida"
                />
                {tramitarErrors.originAddress ? (
                  <span className="tramitar-modal__error">
                    {tramitarErrors.originAddress}
                  </span>
                ) : null}
              </label>

              <label>
                Dirección exacta de entrega
                <input
                  type="text"
                  value={tramitarForm.destinationAddress}
                  onChange={(event) =>
                    setTramitarForm((prev) => ({
                      ...prev,
                      destinationAddress: event.target.value,
                    }))
                  }
                  placeholder="Ej.: Av. del Puerto 45, 46024 Valencia"
                />
                {tramitarErrors.destinationAddress ? (
                  <span className="tramitar-modal__error">
                    {tramitarErrors.destinationAddress}
                  </span>
                ) : null}
              </label>

              <label>
                Persona de contacto
                <input
                  type="text"
                  value={tramitarForm.contactName}
                  onChange={(event) =>
                    setTramitarForm((prev) => ({
                      ...prev,
                      contactName: event.target.value,
                    }))
                  }
                  placeholder="Ej.: Laura Gómez"
                />
                {tramitarErrors.contactName ? (
                  <span className="tramitar-modal__error">
                    {tramitarErrors.contactName}
                  </span>
                ) : null}
              </label>

              <label>
                Teléfono de contacto
                <input
                  type="text"
                  value={tramitarForm.contactPhone}
                  onChange={(event) =>
                    setTramitarForm((prev) => ({
                      ...prev,
                      contactPhone: event.target.value,
                    }))
                  }
                  placeholder="Ej.: 600 123 123"
                />
                {tramitarErrors.contactPhone ? (
                  <span className="tramitar-modal__error">
                    {tramitarErrors.contactPhone}
                  </span>
                ) : null}
              </label>
            </div>

            <div className="tramitar-modal__actions">
              <button
                className="primary-button"
                onClick={handleTramitarSubmit}
                disabled={isLoading}
              >
                Confirmar y tramitar
              </button>
            </div>
          </div>
        </div>
      ) : null}

      {showTramitarSuccess ? (
        <div className="tramitar-modal__overlay">
          <div className="tramitar-modal tramitar-modal--success">
            <h3>Pedido tramitado</h3>
            <p>Te llevo a la pestaña de pedidos.</p>
          </div>
        </div>
      ) : null}

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
                disabled={isLoading || humanChatClosing}
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
                  <div className="bubble-tools">
                    <Tippy
                      content={
                        speakingId === `human-audio-${message.id}`
                          ? "Detener audio"
                          : "Escuchar mensaje"
                      }
                    >
                      <span>
                        <button
                          className="bubble-audio"
                          onClick={() =>
                            speakMessage(
                              message.content,
                              `human-audio-${message.id}`,
                            )
                          }
                          aria-label="Escuchar mensaje"
                        >
                          {speakingId === `human-audio-${message.id}` ? (
                            <AudioMutedIcon />
                          ) : (
                            <AudioPlayIcon />
                          )}
                        </button>
                      </span>
                    </Tippy>
                    <Tippy
                      content={
                        copyFeedbackId === `human-${message.id}`
                          ? "Copiado"
                          : "Copiar"
                      }
                    >
                      <span>
                        <button
                          className="bubble-copy"
                          onClick={() =>
                            copyToClipboard(
                              message.content,
                              `human-${message.id}`,
                            )
                          }
                          aria-label="Copiar mensaje"
                        >
                          <CopyIcon />
                        </button>
                      </span>
                    </Tippy>
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

      {copyToastVisible ? (
        <div className="toast toast--success" role="status" aria-live="polite">
          Ok, se ha copiado el contenido.
        </div>
      ) : null}
    </div>
  );
};

export default AssistantPage;
