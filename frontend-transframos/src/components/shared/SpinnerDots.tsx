import { useId } from "react";

type SpinnerDotsProps = {
  size?: number;
  color?: string;
  className?: string;
};

const SpinnerDots = ({
  size = 24,
  color = "#337040FF",
  className,
}: SpinnerDotsProps) => {
  const uid = useId().replace(/:/g, "");
  const firstId = `spinner_${uid}_a`;
  const lastId = `spinner_${uid}_b`;

  return (
    <svg
      className={className}
      width={size}
      height={size}
      fill={color}
      viewBox="0 0 24 24"
      xmlns="http://www.w3.org/2000/svg"
      role="img"
      aria-label="Procesando solicitud"
    >
      <circle cx="4" cy="12" r="3" opacity="1">
        <animate
          id={firstId}
          begin={`0;${lastId}.end-0.25s`}
          attributeName="opacity"
          dur="0.75s"
          values="1;.2"
          fill="freeze"
        />
      </circle>
      <circle cx="12" cy="12" r="3" opacity=".4">
        <animate
          begin={`${firstId}.begin+0.15s`}
          attributeName="opacity"
          dur="0.75s"
          values="1;.2"
          fill="freeze"
        />
      </circle>
      <circle cx="20" cy="12" r="3" opacity=".3">
        <animate
          id={lastId}
          begin={`${firstId}.begin+0.3s`}
          attributeName="opacity"
          dur="0.75s"
          values="1;.2"
          fill="freeze"
        />
      </circle>
    </svg>
  );
};

export default SpinnerDots;
