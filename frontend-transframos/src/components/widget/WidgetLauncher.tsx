import { useRef } from "react";
import { MessageSquare, ShieldCheck, UserRound } from "lucide-react";
import { useAuthStore } from "@/modules/auth/auth.store";
import { useWidgetStore } from "@/modules/widget/widget.store";

const WidgetLauncher = () => {
  const open = useWidgetStore((state) => state.open);
  const user = useAuthStore((state) => state.user);
  const buttonRef = useRef<HTMLButtonElement>(null);

  const isAdmin = user?.role === "admin";

  const handleOpen = () => {
    const rect = buttonRef.current?.getBoundingClientRect();

    if (!rect) {
      open();
      return;
    }

    open({
      x: rect.left + rect.width / 2,
      y: rect.top + rect.height / 2,
    });
  };

  return (
    <button
      ref={buttonRef}
      className="widget-launcher"
      onClick={handleOpen}
      type="button"
    >
      {/* <span className="widget-launcher__icon">
        {isAdmin ? (
          <ShieldCheck size={20} />
        ) : user ? (
          <UserRound size={20} />
        ) : (
          <MessageSquare size={20} />
        )}
      </span> */}

      <span className="widget-launcher__content">
        <strong>
          Asistente Inteligente
          <br />
          de Pedidos
        </strong>
      </span>
    </button>
  );
};

export default WidgetLauncher;
