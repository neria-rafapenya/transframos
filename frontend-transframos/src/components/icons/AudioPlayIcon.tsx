type AudioPlayIconProps = {
  size?: number;
  className?: string;
};

const AudioPlayIcon = ({ size = 17, className }: AudioPlayIconProps) => (
  <svg
    xmlns="http://www.w3.org/2000/svg"
    width={size}
    height={size}
    viewBox="0 0 17 20"
    fill="none"
    className={className}
    aria-hidden="true"
    focusable="false"
  >
    <path
      d="M8.25 12C8.70682 12.2692 9.08548 12.653 9.34855 13.1133C9.61162 13.5737 9.75 14.0948 9.75 14.625C9.75 15.1552 9.61162 15.6763 9.34855 16.1367C9.08548 16.597 8.70682 16.9808 8.25 17.25M10.5 0.75V6H15.75M10.5 0.75L15.75 6M10.5 0.75H1.5C1.30109 0.75 1.11032 0.829018 0.96967 0.96967C0.829018 1.11032 0.75 1.30109 0.75 1.5V9M15.75 6V18C15.75 18.1989 15.671 18.3897 15.5303 18.5303C15.3897 18.671 15.1989 18.75 15 18.75H12M0.75 16.5V12.75H3L5.25 10.5V18.75L3 16.5H0.75Z"
      stroke="currentColor"
      strokeWidth="1.5"
      strokeLinecap="round"
      strokeLinejoin="round"
    />
  </svg>
);

export default AudioPlayIcon;
