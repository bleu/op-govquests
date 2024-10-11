import { cn } from "@/lib/utils";
import type { LucideIcon } from "lucide-react";
import type React from "react";
import LoadingIndicator from "./LoadingIndicator";
import Spinner from "./Spinner";

interface ButtonProps extends React.ButtonHTMLAttributes<HTMLButtonElement> {
  variant?: "primary" | "secondary";
  size?: "sm" | "md" | "lg";
  icon?: LucideIcon;
  loading?: boolean;
  className?: string;
}

const Button: React.FC<ButtonProps> = ({
  children,
  variant = "primary",
  size = "md",
  icon: Icon,
  loading,
  className,
  ...props
}) => {
  const baseClasses =
    "flex items-center justify-center font-medium rounded-md transition-colors";

  const variantClasses = {
    primary: "bg-primary text-foreground hover:bg-primary/70 transition",
    secondary: "hover:bg-background/70 transition",
  };
  const sizeClasses = {
    sm: "px-3 py-1 text-sm",
    md: "px-4 py-2",
    lg: "px-6 py-3 text-lg",
  };

  return (
    <button
      className={cn(
        baseClasses,
        variantClasses[variant],
        sizeClasses[size],
        className,
      )}
      {...props}
    >
      {loading ? (
        <Spinner />
      ) : (
        <>
          {children}
          {Icon && <Icon className={cn("w-5 h-5", children && "ml-2")} />}
        </>
      )}
    </button>
  );
};

export default Button;
