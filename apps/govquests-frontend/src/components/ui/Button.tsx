import { cn } from "@/lib/utils";
import type { LucideIcon } from "lucide-react";
import type React from "react";

interface ButtonProps extends React.ButtonHTMLAttributes<HTMLButtonElement> {
  variant?: "primary" | "secondary";
  size?: "sm" | "md" | "lg";
  icon?: LucideIcon;
  className?: string;
}

const Button: React.FC<ButtonProps> = ({
  children,
  variant = "primary",
  size = "md",
  icon: Icon,
  className,
  ...props
}) => {
  const baseClasses =
    "flex items-center justify-center font-medium rounded-md transition-colors";

  const variantClasses = {
    primary:
      "bg-optimism text-optimismForeground hover:bg-optimism/70 transition",
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
      {Icon && <Icon className={cn("w-5 h-5", children && "mr-2")} />}
      {children}
    </button>
  );
};

export default Button;
