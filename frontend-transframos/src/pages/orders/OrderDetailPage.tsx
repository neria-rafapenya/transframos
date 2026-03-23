import { useEffect, useState } from "react";
import { Link, useParams } from "react-router-dom";
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

const OrderDetailPage = () => {
  const { id } = useParams();
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
          <Link className="secondary-button" to="/orders">
            Volver a pedidos
          </Link>
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
                <span>Recogida solicitada</span>
                <strong>{formatDate(order.requestedPickupDatetime)}</strong>
              </div>
              <div>
                <span>Entrega solicitada</span>
                <strong>{formatDate(order.requestedDeliveryDatetime)}</strong>
              </div>
              <div>
                <span>Recogida confirmada</span>
                <strong>{formatDate(order.confirmedPickupDatetime)}</strong>
              </div>
              <div>
                <span>Entrega confirmada</span>
                <strong>{formatDate(order.confirmedDeliveryDatetime)}</strong>
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
