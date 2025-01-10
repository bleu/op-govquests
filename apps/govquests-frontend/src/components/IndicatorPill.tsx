import { cn } from "@/lib/utils";
import { ComponentProps } from "react";

export const IndicatorPill = ({
  className,
  ...props
}: ComponentProps<"span">) => {
  return (
<<<<<<< HEAD
    <div
      className={cn(
        "relative border shadow-[1px_1px_0px_0px_#000000] bg-primary border-primary-foreground items-center text-center rounded-lg justify-center flex py-1 px-4",
        className,
      )}
    >
=======
    <div className="relative border shadow-[1px_1px_0px_0px_#000000] bg-primary border-primary-foreground items-center text-center rounded-lg justify-center flex py-1 px-4">
>>>>>>> ca009c899af116cb97a88482de138bdbf29c993f
      <AnchorPoint className="absolute top-1 left-1 " />
      <span
        className="text-primary-foreground text-xs font-bold whitespace-nowrap flex items-center"
        {...props}
      />
      <AnchorPoint className="absolute top-1 right-1 " />
    </div>
  );
};

const AnchorPoint = ({ className }: { className: string }) => {
  return (
    <div
      className={cn(
        "size-[5px] border-[1.5px] border-primary-foreground rounded-full shadow-[0.5px_0.5px_0px_0px_#0000004D]",
        className,
      )}
    />
  );
};
