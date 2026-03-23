import { useEffect, useState } from "react";
import { useNavigate, useParams } from "react-router-dom";
import { ordersApi, type OrderDetail } from "@/modules/orders/orders.api";

const formatDate = (value: string | null) => {
  if (!value) {
    return "—";
  }
  const parsed = new Date(value);
  if (Number.isNaN(parsed.getTime())) {
    return value;
  }
  return new Intl.DateTimeFormat("es-ES", {
    day: "2-digit",
    month: "2-digit",
    year: "numeric",
    hour: "2-digit",
    minute: "2-digit",
  }).format(parsed);
};

const formatConfirmedDate = (value: string | null) => {
  if (!value) {
    return "Pendiente";
  }
  return formatDate(value);
};

const formatLocation = (
  location:
    | {
        city?: string | null;
        postalCode?: string | null;
        addressLine1?: string | null;
        contactName?: string | null;
        contactPhone?: string | null;
      }
    | null
    | undefined,
) => {
  if (!location) {
    return "—";
  }
  const place = [location.city, location.postalCode].filter(Boolean).join(" ");
  const address = location.addressLine1 ?? null;
  const contactParts = [
    location.contactName ?? null,
    location.contactPhone ? `(${location.contactPhone})` : null,
  ].filter(Boolean);
  const contact =
    contactParts.length > 0 ? `Responsable: ${contactParts.join(" ")}` : null;
  return [place, address, contact].filter(Boolean).join(" · ");
};

const OrderDetailPage = () => {
  const { id } = useParams();
  const navigate = useNavigate();
  const [order, setOrder] = useState<OrderDetail | null>(null);
  const [isLoading, setIsLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    if (!id) {
      setError("Pedido no válido.");
      setIsLoading(false);
      return;
    }

    let active = true;
    setIsLoading(true);
    setError(null);

    ordersApi
      .getOrderById(id)
      .then((data) => {
        if (active) {
          setOrder(data);
        }
      })
      .catch((err) => {
        if (active) {
          setError(err instanceof Error ? err.message : "Error inesperado");
        }
      })
      .finally(() => {
        if (active) {
          setIsLoading(false);
        }
      });

    return () => {
      active = false;
    };
  }, [id]);

  return (
    <div className="dashboard-page order-detail-page">
      <section className="panel">
        <div className="panel-header">
          <div>
            <h2>Detalle del pedido</h2>
            <p>Informacion principal del pedido tramitado.</p>
          </div>
          <button
            className="secondary-button"
            type="button"
            onClick={() => {
              if (window.history.length > 1) {
                navigate(-1);
                return;
              }
              navigate("/orders");
            }}
          >
            Volver
          </button>
        </div>

        {isLoading ? <p>Cargando pedido...</p> : null}
        {error ? <p>{error}</p> : null}

        {!isLoading && !error && order ? (
          <>
            <div className="profile-grid">
              <div>
                <span>Numero</span>
                <strong>{order.orderNumber}</strong>
              </div>
              <div>
                <span>Estado</span>
                <strong>{order.orderStatus}</strong>
              </div>
              <div>
                <span>Producto</span>
                <strong>{order.productName ?? "—"}</strong>
              </div>
              <div>
                <span>Tramitado por</span>
                <strong>{order.requesterName ?? "—"}</strong>
              </div>
              <div>
                <span>Vehículo propuesto</span>
                <strong>{order.proposedVehicle?.code ?? "—"}</strong>
              </div>
              <div>
                <span>Matrícula</span>
                <strong>{order.proposedVehicle?.plate ?? "—"}</strong>
              </div>
              <div>
                <span>Recogida solicitada</span>
                <strong>{formatDate(order.requestedPickupDatetime)}</strong>
                <span className="order-detail__meta">
                  {formatLocation(order.origin)}
                </span>
              </div>
              <div>
                <span>Entrega solicitada</span>
                <strong>{formatDate(order.requestedDeliveryDatetime)}</strong>
                <span className="order-detail__meta">
                  {formatLocation(order.destination)}
                </span>
              </div>
              <div>
                <span>Recogida confirmada</span>
                <strong>{formatConfirmedDate(order.confirmedPickupDatetime)}</strong>
              </div>
              <div>
                <span>Entrega confirmada</span>
                <strong>
                  {formatConfirmedDate(order.confirmedDeliveryDatetime)}
                </strong>
              </div>
              <div>
                <span>Volumen</span>
                <strong>{order.orderedVolumeLiters} L</strong>
              </div>
              <div>
                <span>Peso</span>
                <strong>
                  {typeof order.orderedWeightTn === "number"
                    ? `${order.orderedWeightTn} tn`
                    : "—"}
                </strong>
              </div>
              <div>
                <span>Modo servicio</span>
                <strong>{order.serviceMode}</strong>
              </div>
              <div>
                <span>Prioridad</span>
                <strong>{order.priorityLevel ?? "—"}</strong>
              </div>
              <div>
                <span>Referencia cliente</span>
                <strong>{order.clientReference ?? "—"}</strong>
              </div>
              <div>
                <span>Notas</span>
                <strong>{order.internalNotes ?? "—"}</strong>
              </div>
              <div>
                <span>Creado</span>
                <strong>{formatDate(order.createdAt)}</strong>
              </div>
              <div>
                <span>Actualizado</span>
                <strong>{formatDate(order.updatedAt)}</strong>
              </div>
            </div>

            <div className="proposal-card">
              <h4>Seguimiento</h4>
              <p>Proximamente: estado en ruta, hitos y geolocalizacion.</p>
              {/* TODO: incluir seguimiento detallado del pedido */}
            </div>
          </>
        ) : null}
      </section>
    </div>
  );
};

export default OrderDetailPage;
