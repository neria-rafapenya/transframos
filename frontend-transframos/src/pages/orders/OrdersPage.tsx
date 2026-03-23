import { useEffect, useState } from "react";
import { Link } from "react-router-dom";
import { ordersApi, type OrderSummary } from "@/modules/orders/orders.api";

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

const OrdersPage = () => {
  const [orders, setOrders] = useState<OrderSummary[]>([]);
  const [isLoading, setIsLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    let active = true;
    setIsLoading(true);
    setError(null);

    ordersApi
      .getOrders()
      .then((data) => {
        if (active) {
          setOrders(data ?? []);
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
  }, []);

  return (
    <div className="dashboard-page">
      <section className="panel">
        <h2>Pedidos</h2>
        <p>Listado de pedidos cerrados desde el asistente.</p>

        {isLoading ? <p>Cargando pedidos...</p> : null}
        {error ? <p>{error}</p> : null}

        {!isLoading && !error && orders.length === 0 ? (
          <p>No hay pedidos todavía.</p>
        ) : null}

        {!isLoading && !error && orders.length > 0 ? (
          <div className="table-scroll">
            <table className="table">
              <thead>
                <tr>
                  <th>Pedido</th>
                  <th>Estado</th>
                  <th>Recogida</th>
                  <th>Entrega</th>
                  <th>Creado</th>
                </tr>
              </thead>
              <tbody>
                {orders.map((order) => (
                  <tr key={order.id}>
                    <td>
                      <Link to={`/orders/${order.id}`}>
                        {order.orderNumber}
                      </Link>
                    </td>
                    <td>{order.orderStatus}</td>
                    <td>{formatDate(order.requestedPickupDatetime)}</td>
                    <td>{formatDate(order.requestedDeliveryDatetime)}</td>
                    <td>{formatDate(order.createdAt)}</td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        ) : null}
      </section>
    </div>
  );
};

export default OrdersPage;
