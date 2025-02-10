import { cn } from "@/lib/utils";
import type { ComponentProps } from "react";

interface SectionHeaderProps extends ComponentProps<"div"> {
  title: string;
  description?: string;
}

export const SectionHeader = ({
  description,
  title,
  className,
  ...props
}: SectionHeaderProps) => {
  return (
    <div
      className={cn(
        "flex flex-col gap-2 pb-2 border-b border-foreground/20 w-full",
        className,
      )}
      {...props}
    >
      <h1 className="text-2xl font-bold"># {title}</h1>
      {description && <span className="text-xl">{description}</span>}
    </div>
  );
};
