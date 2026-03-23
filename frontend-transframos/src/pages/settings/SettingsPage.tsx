import { useEffect, useMemo, useState } from "react";
import { useNavigate } from "react-router-dom";
import DataTable, { type DataTableColumn } from "@/components/shared/DataTable";
import { settingsApi, type SandboxSnapshot } from "@/modules/settings/settings.api";

const SettingsPage = () => {
  const navigate = useNavigate();
  const [snapshot, setSnapshot] = useState<SandboxSnapshot | null>(null);
  const [isLoading, setIsLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

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
      }).format(parsed);
    }

    return trimmed;
  };

  useEffect(() => {
    let active = true;

    const load = async () => {
      setIsLoading(true);
      setError(null);

      try {
        const data = await settingsApi.getSandboxSnapshot();
        if (!active) return;
        setSnapshot(data);
      } catch (err) {
        if (!active) return;
        const message = err instanceof Error ? err.message : "Error al cargar.";
        setError(message);
      } finally {
        if (active) {
          setIsLoading(false);
        }
      }
    };

    void load();

    return () => {
      active = false;
    };
  }, []);

  const productColumns = useMemo<DataTableColumn<Record<string, unknown>>[]>(
    () => [
      { key: "code", header: "Código" },
      { key: "name", header: "Producto" },
      { key: "commercialName", header: "Comercial" },
      {
        key: "category",
        header: "Categoría",
        render: (row) =>
          (row as any)?.category?.name ?? (row as any)?.categoryId ?? "—",
      },
      { key: "adrRequired", header: "ADR" },
      { key: "foodGradeRequired", header: "Food grade" },
      { key: "isActive", header: "Activo" },
    ],
    [],
  );

  const productById = useMemo(() => {
    const map = new Map<string, Record<string, unknown>>();
    snapshot?.products.forEach((item) => {
      const id = (item as any)?.id as string | undefined;
      if (id) {
        map.set(id, item);
      }
    });
    return map;
  }, [snapshot?.products]);

  const categoryById = useMemo(() => {
    const map = new Map<string, Record<string, unknown>>();
    snapshot?.productCategories.forEach((item) => {
      const id = (item as any)?.id as string | undefined;
      if (id) {
        map.set(id, item);
      }
    });
    return map;
  }, [snapshot?.productCategories]);

  const vehicleById = useMemo(() => {
    const map = new Map<string, Record<string, unknown>>();
    snapshot?.vehicles.forEach((item) => {
      const id = (item as any)?.id as string | undefined;
      if (id) {
        map.set(id, item);
      }
    });
    return map;
  }, [snapshot?.vehicles]);

  const vehicleIdsByTankId = useMemo(() => {
    const map = new Map<string, string[]>();
    snapshot?.vehicleTanks.forEach((item) => {
      const tankId = (item as any)?.tankId as string | undefined;
      const vehicleId = (item as any)?.vehicleId as string | undefined;
      if (!tankId || !vehicleId) return;
      const list = map.get(tankId) ?? [];
      list.push(vehicleId);
      map.set(tankId, list);
    });
    return map;
  }, [snapshot?.vehicleTanks]);

  const tankById = useMemo(() => {
    const map = new Map<string, Record<string, unknown>>();
    snapshot?.tanks.forEach((item) => {
      const id = (item as any)?.id as string | undefined;
      if (id) {
        map.set(id, item);
      }
    });
    return map;
  }, [snapshot?.tanks]);

  const loadingPointById = useMemo(() => {
    const map = new Map<string, Record<string, unknown>>();
    snapshot?.loadingPoints.forEach((item) => {
      const id = (item as any)?.id as string | undefined;
      if (id) {
        map.set(id, item);
      }
    });
    return map;
  }, [snapshot?.loadingPoints]);

  const unloadingPointById = useMemo(() => {
    const map = new Map<string, Record<string, unknown>>();
    snapshot?.unloadingPoints.forEach((item) => {
      const id = (item as any)?.id as string | undefined;
      if (id) {
        map.set(id, item);
      }
    });
    return map;
  }, [snapshot?.unloadingPoints]);

  const routeById = useMemo(() => {
    const map = new Map<string, Record<string, unknown>>();
    snapshot?.routes.forEach((item) => {
      const id = (item as any)?.id as string | undefined;
      if (id) {
        map.set(id, item);
      }
    });
    return map;
  }, [snapshot?.routes]);

  const categoryColumns = useMemo<DataTableColumn<Record<string, unknown>>[]>(
    () => [
      { key: "code", header: "Código" },
      { key: "name", header: "Categoría" },
      { key: "requiresFoodGrade", header: "Food grade" },
      { key: "requiresAdr", header: "ADR" },
      { key: "isActive", header: "Activo" },
    ],
    [],
  );

  const compatibilityColumns = useMemo<
    DataTableColumn<Record<string, unknown>>[]
  >(
    () => [
      {
        key: "previousProductId",
        header: "Producto previo",
        render: (row) => {
          const id = (row as any)?.previousProductId as string | null;
          if (!id) return "—";
          const product = productById.get(id) as any;
          return product?.name ?? product?.code ?? id;
        },
      },
      {
        key: "nextProductId",
        header: "Producto siguiente",
        render: (row) => {
          const id = (row as any)?.nextProductId as string | null;
          if (!id) return "—";
          const product = productById.get(id) as any;
          return product?.name ?? product?.code ?? id;
        },
      },
      {
        key: "previousCategoryId",
        header: "Categoría previa",
        render: (row) => {
          const id = (row as any)?.previousCategoryId as string | null;
          if (!id) return "—";
          const category = categoryById.get(id) as any;
          return category?.name ?? category?.code ?? id;
        },
      },
      {
        key: "nextCategoryId",
        header: "Categoría siguiente",
        render: (row) => {
          const id = (row as any)?.nextCategoryId as string | null;
          if (!id) return "—";
          const category = categoryById.get(id) as any;
          return category?.name ?? category?.code ?? id;
        },
      },
      { key: "compatibilityStatus", header: "Estado" },
      { key: "cleaningRequired", header: "Limpieza" },
      { key: "requiredCleaningType", header: "Tipo limpieza" },
      { key: "bacteriologicalFilterRequired", header: "Filtro" },
      {
        key: "coolingOrHeatingResetRequired",
        header: "Reset térmico",
      },
      { key: "rationale", header: "Explicación", wrap: true },
      { key: "isActive", header: "Activo" },
    ],
    [productById, categoryById],
  );

  const vehicleColumns = useMemo<DataTableColumn<Record<string, unknown>>[]>(
    () => [
      { key: "code", header: "Código" },
      { key: "plateNumber", header: "Matrícula" },
      { key: "vehicleTypeCode", header: "Tipo" },
      { key: "homeBase", header: "Base" },
      { key: "maxDailyKm", header: "Km/día" },
      { key: "isActive", header: "Activo" },
    ],
    [],
  );

  const availabilityColumns = useMemo<
    DataTableColumn<Record<string, unknown>>[]
  >(
    () => [
      {
        key: "vehicleId",
        header: "Matrícula",
        render: (row) => {
          const id = (row as any)?.vehicleId as string | null;
          if (!id) return "—";
          const vehicle = snapshot?.vehicles.find(
            (item) => (item as any)?.id === id,
          ) as any;
          return vehicle?.plateNumber ?? vehicle?.code ?? id;
        },
      },
      {
        key: "availabilityDate",
        header: "Fecha",
        render: (row) => {
          const value = (row as any)?.availabilityDate as string | null;
          return formatDateDisplay(value) ?? value ?? "—";
        },
      },
      { key: "available", header: "Disponible" },
      { key: "plannedKmLimit", header: "Km límite" },
      { key: "currentLocation", header: "Ubicación" },
    ],
    [snapshot?.vehicles, formatDateDisplay],
  );

  const tankColumns = useMemo<DataTableColumn<Record<string, unknown>>[]>(
    () => [
      { key: "code", header: "Código" },
      {
        key: "vehicleId",
        header: "Matrícula",
        render: (row) => {
          const tankId = (row as any)?.id as string | undefined;
          if (!tankId) return "—";
          const vehicleIds = vehicleIdsByTankId.get(tankId) ?? [];
          if (vehicleIds.length === 0) return "—";
          const labels = vehicleIds.map((vehicleId) => {
            const vehicle = vehicleById.get(vehicleId) as any;
            return vehicle?.plateNumber ?? vehicle?.code ?? vehicleId;
          });
          return labels.join(", ");
        },
      },
      { key: "type", header: "Tipo" },
      { key: "capacityLiters", header: "Capacidad" },
      { key: "temperatureControl", header: "Temp" },
      { key: "bacteriologicalFilter", header: "Filtro" },
      { key: "isActive", header: "Activo" },
    ],
    [vehicleIdsByTankId, vehicleById],
  );

  const tankAuthColumns = useMemo<DataTableColumn<Record<string, unknown>>[]>(
    () => [
      {
        key: "tankId",
        header: "Tanque",
        render: (row) => {
          const id = (row as any)?.tankId as string | null;
          if (!id) return "—";
          const tank = tankById.get(id) as any;
          return tank?.code ?? id;
        },
      },
      {
        key: "categoryId",
        header: "Categoría",
        render: (row) => {
          const id = (row as any)?.categoryId as string | null;
          if (!id) return "—";
          const category = categoryById.get(id) as any;
          return category?.name ?? category?.code ?? id;
        },
      },
      {
        key: "productId",
        header: "Producto",
        render: (row) => {
          const id = (row as any)?.productId as string | null;
          if (!id) return "—";
          const product = productById.get(id) as any;
          return product?.name ?? product?.code ?? id;
        },
      },
      { key: "allowed", header: "Permitido" },
      { key: "authorizationType", header: "Tipo" },
    ],
    [tankById, categoryById, productById],
  );

  const vehicleTankColumns = useMemo<
    DataTableColumn<Record<string, unknown>>[]
  >(
    () => [
      { key: "vehicleId", header: "Vehículo" },
      { key: "tankId", header: "Tanque" },
      { key: "isActive", header: "Activo" },
      {
        key: "validFrom",
        header: "Desde",
        render: (row) => {
          const value = (row as any)?.validFrom as string | null;
          return formatDateDisplay(value) ?? value ?? "—";
        },
      },
      {
        key: "validTo",
        header: "Hasta",
        render: (row) => {
          const value = (row as any)?.validTo as string | null;
          return formatDateDisplay(value) ?? value ?? "—";
        },
      },
    ],
    [formatDateDisplay],
  );

  const routesColumns = useMemo<DataTableColumn<Record<string, unknown>>[]>(
    () => [
      { key: "code", header: "Código" },
      { key: "name", header: "Ruta" },
      {
        key: "originLoadingPointId",
        header: "Origen",
        render: (row) => {
          const id = (row as any)?.originLoadingPointId as string | null;
          if (!id) return "—";
          const point = loadingPointById.get(id) as any;
          return point?.name ?? point?.code ?? id;
        },
      },
      {
        key: "destinationUnloadingPointId",
        header: "Destino",
        render: (row) => {
          const id = (row as any)?.destinationUnloadingPointId as string | null;
          if (!id) return "—";
          const point = unloadingPointById.get(id) as any;
          return point?.name ?? point?.code ?? id;
        },
      },
      { key: "standardDistanceKm", header: "Km" },
      { key: "standardDurationMinutes", header: "Min" },
    ],
    [loadingPointById, unloadingPointById],
  );

  const vehicleRouteColumns = useMemo<
    DataTableColumn<Record<string, unknown>>[]
  >(
    () => [
      {
        key: "vehicleId",
        header: "Vehículo",
        render: (row) => {
          const id = (row as any)?.vehicleId as string | null;
          if (!id) return "—";
          const vehicle = vehicleById.get(id) as any;
          return vehicle?.plateNumber ?? vehicle?.code ?? id;
        },
      },
      {
        key: "routeId",
        header: "Ruta",
        render: (row) => {
          const id = (row as any)?.routeId as string | null;
          if (!id) return "—";
          const route = routeById.get(id) as any;
          return route?.name ?? route?.code ?? id;
        },
      },
      { key: "isActive", header: "Activo" },
      {
        key: "validFrom",
        header: "Desde",
        render: (row) => {
          const value = (row as any)?.validFrom as string | null;
          return formatDateDisplay(value) ?? value ?? "—";
        },
      },
      {
        key: "validTo",
        header: "Hasta",
        render: (row) => {
          const value = (row as any)?.validTo as string | null;
          return formatDateDisplay(value) ?? value ?? "—";
        },
      },
    ],
    [vehicleById, routeById, formatDateDisplay],
  );

  const waypointColumns = useMemo<DataTableColumn<Record<string, unknown>>[]>(
    () => [
      {
        key: "routeId",
        header: "Ruta",
        render: (row) => {
          const id = (row as any)?.routeId as string | null;
          if (!id) return "—";
          const route = routeById.get(id) as any;
          return route?.name ?? route?.code ?? id;
        },
      },
      { key: "sequenceNo", header: "Orden" },
      { key: "waypointName", header: "Parada" },
      { key: "city", header: "Ciudad" },
    ],
    [routeById],
  );

  const loadingColumns = useMemo<DataTableColumn<Record<string, unknown>>[]>(
    () => [
      { key: "code", header: "Código" },
      { key: "name", header: "Nombre" },
      { key: "city", header: "Ciudad" },
      { key: "addressLine1", header: "Dirección" },
      { key: "allowedVehicleTypes", header: "Tipos" },
      { key: "isActive", header: "Activo" },
    ],
    [],
  );

  const unloadingColumns = useMemo<DataTableColumn<Record<string, unknown>>[]>(
    () => [
      { key: "code", header: "Código" },
      { key: "name", header: "Nombre" },
      { key: "city", header: "Ciudad" },
      { key: "addressLine1", header: "Dirección" },
      { key: "allowedVehicleTypes", header: "Tipos" },
      { key: "isActive", header: "Activo" },
    ],
    [],
  );

  return (
    <div className="sandbox-page">
      <header className="sandbox-header">
        <div>
          <h1>Sandbox Settings</h1>
          <p>Listado de catálogos operativos para pruebas rápidas.</p>
        </div>
        <div className="sandbox-header__actions">
          <button type="button" onClick={() => navigate("/dashboard")}>
            Volver al dashboard
          </button>
        </div>
      </header>

      {isLoading ? (
        <div className="sandbox-status">Cargando datos del sandbox…</div>
      ) : error ? (
        <div className="sandbox-status sandbox-status--error">
          <p>{error}</p>
          <button type="button" onClick={() => window.location.reload()}>
            Reintentar
          </button>
        </div>
      ) : snapshot ? (
        <div className="sandbox-grid">
          <DataTable
            title="Productos"
            rows={snapshot.products}
            columns={productColumns}
          />
          <DataTable
            title="Categorías de producto"
            rows={snapshot.productCategories}
            columns={categoryColumns}
          />
          <DataTable
            title="Reglas de compatibilidad"
            rows={snapshot.compatibilityRules}
            columns={compatibilityColumns}
            description="Reglas de transición entre producto previo y siguiente en un mismo tanque."
          />
          <DataTable
            title="Vehículos"
            rows={snapshot.vehicles}
            columns={vehicleColumns}
          />
          <DataTable
            title="Disponibilidad de vehículos"
            rows={snapshot.vehicleAvailability}
            columns={availabilityColumns}
            description="Registro diario de disponibilidad de vehículos y su ubicación prevista."
          />
          <DataTable
            title="Tanques"
            rows={snapshot.tanks}
            columns={tankColumns}
          />
          <DataTable
            title="Autorizaciones tanque-producto"
            rows={snapshot.tankAuthorizations}
            columns={tankAuthColumns}
            description="Reglas que indican qué tanque puede transportar una categoría o un producto específico."
          />
          <DataTable
            title="Rutas"
            rows={snapshot.routes}
            columns={routesColumns}
            description="Rutas base para estimaciones. En operación real pueden definirse rutas específicas por pedido."
          />
          <DataTable
            title="Relación vehículo-ruta"
            rows={snapshot.vehicleRoutes}
            columns={vehicleRouteColumns}
            description="Asignación fija de vehículos a rutas preferidas para planificación operativa."
          />
          <DataTable
            title="Waypoints de ruta"
            rows={snapshot.routeWaypoints}
            columns={waypointColumns}
          />
          <DataTable
            title="Puntos de carga"
            rows={snapshot.loadingPoints}
            columns={loadingColumns}
          />
          <DataTable
            title="Puntos de descarga"
            rows={snapshot.unloadingPoints}
            columns={unloadingColumns}
          />
        </div>
      ) : (
        <div className="sandbox-status">Sin datos.</div>
      )}
    </div>
  );
};

export default SettingsPage;
