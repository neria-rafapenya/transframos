import { useEffect, useRef } from "react";
import type { RoutePreview } from "@/modules/assistant/assistant.types";

type RoutePreviewMapProps = {
  routePreview: RoutePreview | null;
  redrawKey?: number;
};

const SPAIN_BOUNDS = {
  minLon: -9.27,
  maxLon: 3.32,
  minLat: 36.97,
  maxLat: 42.88,
};

// Ajuste fino: ampliamos ligeramente el rango sur para alinear mejor el SVG con
// las coordenadas reales (evita que el destino quede demasiado abajo).
const SOUTH_LAT_PADDING = 0.25;

const MAP_VIEWBOX = {
  width: 278,
  height: 231,
};

const RoutePreviewMap = ({ routePreview, redrawKey }: RoutePreviewMapProps) => {
  const routeCanvasRef = useRef<HTMLCanvasElement | null>(null);
  const mapPathRef = useRef<SVGPathElement | null>(null);

  useEffect(() => {
    const canvas = routeCanvasRef.current;
    if (!canvas) {
      return;
    }

    const ctx = canvas.getContext("2d");
    if (!ctx) {
      return;
    }

    const draw = () => {
      const rect = canvas.getBoundingClientRect();
      const width = rect.width || 320;
      const height = rect.height || 200;
      const ratio = window.devicePixelRatio || 1;

      canvas.width = width * ratio;
      canvas.height = height * ratio;
      ctx.setTransform(ratio, 0, 0, ratio, 0, 0);

      const viewBoxWidth = MAP_VIEWBOX.width;
      const viewBoxHeight = MAP_VIEWBOX.height;
      const scale = Math.min(width / viewBoxWidth, height / viewBoxHeight);
      const offsetX = (width - viewBoxWidth * scale) / 2;
      const offsetY = (height - viewBoxHeight * scale) / 2;

      const mapBounds = (() => {
        try {
          const bbox = mapPathRef.current?.getBBox?.();
          if (
            !bbox ||
            !Number.isFinite(bbox.width) ||
            !Number.isFinite(bbox.height)
          ) {
            return {
              x: 0,
              y: 0,
              width: viewBoxWidth,
              height: viewBoxHeight,
            };
          }
          return {
            x: bbox.x,
            y: bbox.y,
            width: bbox.width || viewBoxWidth,
            height: bbox.height || viewBoxHeight,
          };
        } catch {
          return {
            x: 0,
            y: 0,
            width: viewBoxWidth,
            height: viewBoxHeight,
          };
        }
      })();

      const project = (lon: number, lat: number) => {
        const minLon = SPAIN_BOUNDS.minLon;
        const maxLon = SPAIN_BOUNDS.maxLon;
        const minLat = SPAIN_BOUNDS.minLat - SOUTH_LAT_PADDING;
        const maxLat = SPAIN_BOUNDS.maxLat;
        const x =
          ((lon - minLon) / (maxLon - minLon)) *
            mapBounds.width +
          mapBounds.x;
        const y =
          ((maxLat - lat) / (maxLat - minLat)) *
            mapBounds.height +
          mapBounds.y;
        return { x: offsetX + x * scale, y: offsetY + y * scale };
      };

      ctx.clearRect(0, 0, width, height);

      if (!routePreview?.origin || !routePreview?.destination) {
        ctx.fillStyle = "#64748b";
        ctx.font = "12px Inter, system-ui, Arial, sans-serif";
        ctx.fillText(
          "Ruta pendiente",
          offsetX + 12,
          offsetY + viewBoxHeight * scale - 12,
        );
        return;
      }

      const origin = project(routePreview.origin.lon, routePreview.origin.lat);
      const destination = project(
        routePreview.destination.lon,
        routePreview.destination.lat,
      );

      const midX = (origin.x + destination.x) / 2;
      const midY = (origin.y + destination.y) / 2 - 24;

      ctx.strokeStyle = "#ffffff";
      ctx.lineWidth = 2.5;
      ctx.setLineDash([7, 6]);
      ctx.beginPath();
      ctx.moveTo(origin.x, origin.y);
      ctx.quadraticCurveTo(midX, midY, destination.x, destination.y);
      ctx.stroke();
      ctx.setLineDash([]);

      const drawMarker = (point: { x: number; y: number }, color: string) => {
        ctx.beginPath();
        ctx.arc(point.x, point.y, 5.5, 0, Math.PI * 2);
        ctx.fillStyle = color;
        ctx.fill();
        ctx.lineWidth = 2;
        ctx.strokeStyle = "#ffffff";
        ctx.stroke();
      };

      drawMarker(origin, "#0ea5a4");
      drawMarker(destination, "#f97316");

      const drawLabel = (text: string, x: number, y: number) => {
        ctx.save();
        ctx.font = "11px Inter, system-ui, Arial, sans-serif";
        const paddingX = 6;
        const paddingY = 3;
        const metrics = ctx.measureText(text);
        const textWidth = metrics.width;
        const boxWidth = textWidth + paddingX * 2;
        const boxHeight = 16;
        const radius = 7;

        const boxX = x;
        const boxY = y - boxHeight;

        ctx.beginPath();
        ctx.moveTo(boxX + radius, boxY);
        ctx.lineTo(boxX + boxWidth - radius, boxY);
        ctx.quadraticCurveTo(
          boxX + boxWidth,
          boxY,
          boxX + boxWidth,
          boxY + radius,
        );
        ctx.lineTo(boxX + boxWidth, boxY + boxHeight - radius);
        ctx.quadraticCurveTo(
          boxX + boxWidth,
          boxY + boxHeight,
          boxX + boxWidth - radius,
          boxY + boxHeight,
        );
        ctx.lineTo(boxX + radius, boxY + boxHeight);
        ctx.quadraticCurveTo(
          boxX,
          boxY + boxHeight,
          boxX,
          boxY + boxHeight - radius,
        );
        ctx.lineTo(boxX, boxY + radius);
        ctx.quadraticCurveTo(boxX, boxY, boxX + radius, boxY);
        ctx.closePath();

        ctx.fillStyle = "rgba(15, 23, 42, 0.9)";
        ctx.fill();

        ctx.fillStyle = "#ffffff";
        ctx.fillText(text, boxX + paddingX, boxY + boxHeight - paddingY);
        ctx.restore();
      };

      drawLabel("Origen", origin.x + 10, origin.y - 6);
      drawLabel("Destino", destination.x + 10, destination.y - 6);
    };

    draw();
    window.addEventListener("resize", draw);

    return () => {
      window.removeEventListener("resize", draw);
    };
  }, [routePreview, redrawKey]);

  return (
    <>
      <div className="route-preview__map">
        <svg
          className="route-preview__svg"
          viewBox={`0 0 ${MAP_VIEWBOX.width} ${MAP_VIEWBOX.height}`}
          preserveAspectRatio="xMidYMid meet"
          aria-hidden="true"
        >
          <path
            ref={mapPathRef}
            d="M38.1465 1.00977L39.8584 0.625977L40.1582 0.556641L42.5928 1.83984L42.707 1.90039L45.3789 4.53516L49.2061 5.3877L52.5068 4.39941L52.5938 4.375L52.6836 4.36719L58.8096 3.89648L58.876 3.8916L61.8838 4.1377L67.249 3.20898L67.333 3.19434L67.417 3.19824L70.376 3.29102L75.3564 1.70508L75.6465 1.61133L75.9287 1.72754L79.6221 3.25977L87.1152 3.73535L87.1982 3.75684L91.6504 4.9834L104.084 6.8418L108.501 6.65527L114.854 5.04492L117.792 3.81738L118.041 3.86816L120.303 4.32031L123.791 3.05566L123.967 2.99316L124.151 3.00879L126.125 3.18945L126.311 3.31641L128.442 4.78809L135.928 6.54785L137.729 4.85352L137.885 4.70898L139.667 4.16016L139.852 4.10352L140.042 4.13281L145.871 5.04688L145.95 5.05957L146.026 5.08594L151.78 7.16992L154.612 7.20703L158.908 6.38477L163.941 4.10352L165.024 6.87988L167.312 7.75977L170.587 8.01562L170.763 8.03027L170.922 8.11426L172.265 8.84473L172.815 9.1416L172.491 12.6201L171.559 14.3145L171.799 14.5039L172.31 14.4736L173.854 12.0303L175.207 13.8916L177.376 14.7686L182.567 16.5186L186.67 16.627L187.352 17.7607L190.416 20.4082L194.115 20.0127L196.552 19.3516L196.851 19.5215L200.419 21.5352L200.462 21.5586L202.421 22.9805L207.387 21.9521L207.698 21.8867L207.976 22.0488L208.946 22.6094L211.348 22.3154L211.433 22.3057L211.518 22.3125L214.562 22.5674L216.253 22.4209L216.506 20.0605L216.536 19.7852L217.94 17.8154L219.935 18.001L220.001 18.0088L220.067 18.0254L225.531 19.4619L225.574 19.4727L225.614 19.4873L229.916 21.1094L231.648 21.1152H231.802L231.947 21.1709L233.462 21.7617L235.719 24.9541L235.447 26.5762L235.743 28.3975L236.343 28.7158L238.104 28.1445L240.625 26.7148L240.956 26.5283L241.309 26.6465L244.774 27.8145L244.836 27.8369L244.895 27.8662L246.448 28.6748L246.63 28.7686L247.914 30.5029L248.296 30.5361L251.954 28.4141L252.258 28.4707L256.171 29.1924L256.193 29.1982L260.482 30.2461L261.503 30.2812L261.652 29.5654L261.761 29.0479L267.077 26.8096L267.146 26.7939L269.045 26.3457L269.224 26.3828L273.21 27.2197L275.017 27.1367L275.266 27.7275L275.889 29.209L276.74 29.6904L277.05 29.8643L278 32.7373L277.103 33.0547L274.64 33.9219L274.541 35.4219L275.901 36.5156L276.086 36.6641L276.181 36.8896L276.525 37.708L276.58 37.8408L276.6 37.9854L277.143 42.3965L274.757 45.2471L274.723 45.2881L274.682 45.3271L271.616 48.2373L271.537 48.2852L256.628 57.6221L253.244 61.8955L253.169 61.9883L251.711 63.1055L251.572 63.209L239.928 66.4287L231.954 69.6475L231.921 69.6582L231.89 69.668L228.247 70.8125L223.707 75.8428L223.683 75.8711L223.654 75.8975L222.747 76.7568L222.9 76.7949L223.135 76.8516L223.31 77.0312L226.118 79.8955L224.862 81.9189L224.639 82.0352L220.175 84.3809L219.998 84.4756L219.802 84.4795L218.836 84.5029L214.087 92.9922L214.062 93.0342L214.034 93.0752L209.475 99.6436L209.435 99.6895L206.921 102.479L204.386 106.594L198.963 117.229L198.984 119.899L202.044 130.159L203.641 132.679L205.82 134.729L210.145 136.491L210.42 136.604L210.578 136.872L211.724 138.801L212.082 139.4L210.11 142.011L210.024 142.081L205.686 145.644L205.645 145.678L205.602 145.704L198.105 150.546L195.18 153.979L194.527 157.6L192.302 159.27L191.602 163.775L191.587 163.873L191.555 163.966L189.962 168.469L189.919 168.545L188.608 170.888L188.507 171.962L191.516 174.849L187.972 177.331L185.022 177.783L184.992 177.788L184.962 177.791L175.948 178.502L168.853 183.958L165.33 188.666L162.068 197.58L162.015 197.724L161.925 197.844L157.82 203.286L157.704 203.442L157.54 203.535L155.715 204.587L155.225 204.867L152.141 202.504L148.999 202.328L145.938 203.144L144.316 204.879L144.178 205.028L143.995 205.103L140.916 206.35L138.002 205.545L132.203 205.342L129.735 205.536L125.719 207.15L125.474 207.249L125.22 207.189L121.747 206.384L115.932 206.153L103.146 207.891L101.847 208.398L100.354 210.453L100.305 210.524L100.243 210.584L95.8076 214.841L89.3633 215.269L83.9424 217.823L82.6758 219.231L80.3008 223.448L79.1768 227.769L77.4111 226.632L76.9102 228.956L76.5293 229.168L74.3496 230.366L74.2578 230.418L74.1572 230.444L72.0928 231L67.4678 229.143L67.3564 229.098L63.8916 226.413L61.8135 226.281L58.5898 221.49L58.54 221.417L57.2637 218.484L57.2334 218.418L57.2148 218.347L56.333 215.117L56.334 214.972L56.3398 213.455L53.752 212.382L53.0781 209.037L52.999 208.649L54.0615 206.761L51.6455 202.549L42.7637 195.637L42.3252 195.297L41.5195 195.703L41.3291 195.799L41.1191 195.795L36.4736 195.685L30.1338 197.013L28.2793 183.286L29.999 178.572L30.0645 178.395L31.7461 176.463L33.9551 172.692L36.8408 169.26L40.54 167.966L41.5244 165.441L39.5244 165.649L38.9971 165.706L33.334 156.634L34.4951 152.865L35.333 148.113L37.0938 146.084L37.1611 146.03L39.3516 144.284L41.1631 141.959L42.0947 139.812L42.3193 138.172L41.7637 137.319L39.1514 136.686L38.7393 136.584L38.5518 136.174L35.7979 130.192L35.7314 130.05L35.7109 129.89L35.2783 126.49L33.0146 124.574L32.9268 124.399L30.5293 119.675L33.501 118.659L33.6133 118.62L33.7305 118.615L41.2441 118.246L42.7559 117.41L44.1094 115.122L45.7275 111.076L46.1221 108.947L45.8926 108.387L43.2471 105.688L43.7686 103.174L43.8447 102.806L47.7393 99.7266L48.4346 98.9521L47.8174 97.3379L47.8486 97.0771L48.5918 90.7979L48.6201 90.708L48.876 89.8633L48.3584 83.6338L46.8262 79.4746L48.3779 77.2373L48.5557 77.1338L50.8369 75.8057L52.791 72.7949L52.8555 72.6953L52.9414 72.6143L55.9326 69.8105L56.0146 69.7607L59.6875 67.5391L62.2148 65.2119L63.665 63.374L63.3213 62.2002L62.2754 61.3682L60.7148 60.8535L57.5039 60.8145L56.9014 60.8057L56.3604 59.2881L56.29 59.0889L56.5635 54.2764L55.8135 53.1299L54.4512 53.3525L54.2773 53.3809L54.1084 53.3359L51.6924 52.7041L51.0479 53.21L47.1055 53.2266L46.9795 53.2275L44.7246 52.5342L44.2471 52.8799L43.832 54.6338L43.5312 54.8447L42.1748 55.7998L42.0693 55.874L38.7793 56.9873L36.085 57.043L35.9424 56.9941L32.2334 55.7051L27.9082 56.3984L27.584 56.4492L27.3066 56.2617L27.2168 56.2012L23.6855 58.1436L23.4727 58.2598L20.9688 58.1367L19.582 55.0811L20.0469 53.7695L20.0977 53.623L20.1895 53.499L21.8418 51.2822L20.7656 49.0801L20.3525 49.0615L19.2676 49.6484L19.1943 49.6875L19.1162 49.7129L14.3623 51.2119L11.2012 53.0352L9.04688 55.0068L8.89062 55.1494L8.69434 55.2061L6.51465 55.8418L5.3291 54.6045L5.53711 49.1963L5.79102 48.9199L9.07129 45.374L7.3252 45.2529L7.76465 42.7422L7.8125 42.4668L9.2959 40.6953L7.97363 39.4346L8.29199 35.6338L5.67578 36.7822L5.43164 36.8906L4.21191 36.6426L3.43555 36.4863L3.62695 33.3281L3.82031 33.0781L5.80371 30.5068L4.61621 30.3506L4.38672 30.3213L4.2002 30.1738L2.45801 28.793L2.34375 28.7021L2.2627 28.5801L0.197266 25.4873L0 25.1904L0.168945 23.1494L0.182617 22.9902L0.243164 22.8438L1.9668 18.5342L5.65625 16.4062L9.36426 13.3779L9.69629 13.4014L14.0059 13.6982L16.5908 13.0508L19.0938 11.6104L19.1973 11.5498L19.3086 11.5225L20.6611 11.168L22.4736 10.1865L22.4951 9.45508L21.9551 8.5332L21.627 7.97363L22.8818 6.08301L23.0566 5.97754L28.7246 2.50293L28.873 2.41113L29.042 2.38574L32.1982 1.90039L35.5283 0.186523L35.8887 0L38.1465 1.00977ZM30.8906 195.855V195.857L36.4121 194.7L41.1494 194.812L36.4111 194.699L30.8906 195.855ZM38.6445 56.0068L36.2266 56.0576L38.6436 56.0088L41.6914 54.9766L38.6445 56.0068Z"
            fill="url(#paint0_linear_160_2)"
          />
          <defs>
            <linearGradient
              id="paint0_linear_160_2"
              x1="1"
              y1="109.5"
              x2="278"
              y2="109.5"
              gradientUnits="userSpaceOnUse"
            >
              <stop offset="0.30137" stopColor="#00A58F" />
              <stop offset="1" stopColor="#00A86E" />
            </linearGradient>
          </defs>
        </svg>
        <canvas ref={routeCanvasRef} className="route-preview__canvas" />
      </div>

      {/* {routePreview?.origin && routePreview?.destination ? (
        <p className="route-preview__coords">
          Origen: {routePreview.origin.lat.toFixed(4)},{" "}
          {routePreview.origin.lon.toFixed(4)} · Destino:{" "}
          {routePreview.destination.lat.toFixed(4)},{" "}
          {routePreview.destination.lon.toFixed(4)}
        </p>
      ) : null} */}
    </>
  );
};

export default RoutePreviewMap;
