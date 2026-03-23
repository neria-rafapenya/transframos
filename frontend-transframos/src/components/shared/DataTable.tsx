import { useEffect, useMemo, useState } from "react";

export type DataTableColumn<T> = {
  key: string;
  header: string;
  align?: "left" | "center" | "right";
  wrap?: boolean;
  render?: (row: T) => React.ReactNode;
};

type DataTableProps<T> = {
  title: string;
  description?: string;
  rows: T[];
  columns: DataTableColumn<T>[];
  pageSize?: number;
  emptyMessage?: string;
};

const formatCell = (value: unknown) => {
  if (value === null || value === undefined) {
    return "—";
  }

  if (typeof value === "boolean") {
    return value ? "Sí" : "No";
  }

  if (typeof value === "object") {
    return JSON.stringify(value);
  }

  return String(value);
};

const DataTable = <T,>({
  title,
  description,
  rows,
  columns,
  pageSize = 20,
  emptyMessage = "Sin registros.",
}: DataTableProps<T>) => {
  const [page, setPage] = useState(1);

  const totalPages = Math.max(1, Math.ceil(rows.length / pageSize));
  const safePage = Math.min(page, totalPages);

  useEffect(() => {
    setPage(1);
  }, [rows, pageSize]);

  const pagedRows = useMemo(() => {
    const start = (safePage - 1) * pageSize;
    return rows.slice(start, start + pageSize);
  }, [rows, safePage, pageSize]);

  return (
    <section className="sandbox-section">
      <div className="sandbox-section__header">
        <div>
          <h3>{title}</h3>
          {description ? (
            <p className="data-table__description">{description}</p>
          ) : null}
          <p>
            Mostrando {rows.length === 0 ? 0 : (safePage - 1) * pageSize + 1}-
            {Math.min(safePage * pageSize, rows.length)} de {rows.length}
          </p>
        </div>
        {totalPages > 1 ? (
          <div className="data-table__pager">
            <button
              type="button"
              onClick={() => setPage((prev) => Math.max(1, prev - 1))}
              disabled={safePage === 1}
            >
              Anterior
            </button>
            <span>
              Página {safePage} de {totalPages}
            </span>
            <button
              type="button"
              onClick={() => setPage((prev) => Math.min(totalPages, prev + 1))}
              disabled={safePage === totalPages}
            >
              Siguiente
            </button>
          </div>
        ) : null}
      </div>

      <div className="data-table__wrapper">
        <table className="data-table">
          <thead>
            <tr>
              {columns.map((column) => (
                <th
                  key={column.key}
                  data-align={column.align ?? "left"}
                  data-wrap={column.wrap ? "true" : "false"}
                >
                  {column.header}
                </th>
              ))}
            </tr>
          </thead>
          <tbody>
            {pagedRows.length === 0 ? (
              <tr>
                <td colSpan={columns.length} className="data-table__empty">
                  {emptyMessage}
                </td>
              </tr>
            ) : (
              pagedRows.map((row, rowIndex) => (
                <tr key={rowIndex}>
                  {columns.map((column) => (
                    <td
                      key={column.key}
                      data-align={column.align ?? "left"}
                      data-wrap={column.wrap ? "true" : "false"}
                    >
                      {column.render
                        ? column.render(row)
                        : formatCell(
                            (row as Record<string, unknown>)[column.key],
                          )}
                    </td>
                  ))}
                </tr>
              ))
            )}
          </tbody>
        </table>
      </div>
    </section>
  );
};

export default DataTable;
