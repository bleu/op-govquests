import { cn } from "@/lib/utils";
import { ComponentProps, ReactNode } from "react";

export const DividerHeader = ({
  children,
  className,
}: ComponentProps<"div">) => {
  return (
    <div className="flex items-center justify-center w-full gap-9">
      <div className="border-b h-0 w-full" />
      <div
        className={cn(
          "text-xl font-medium text-foreground/50 whitespace-nowrap",
          className,
        )}
      >
        {children}
      </div>
      <div className="border-b h-0 w-full" />
    </div>
  );
};
