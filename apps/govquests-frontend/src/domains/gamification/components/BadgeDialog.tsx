import { Dialog, DialogTrigger } from "@/components/ui/dialog";
import type { DialogProps } from "@radix-ui/react-dialog";
import { BadgeDetails } from "./BadgeDetails";
import { useState } from "react";

interface BadgeDialogInterface extends DialogProps {
  badgeId: string;
  children: React.ReactNode;
  special?: boolean;
  className?: string;
  defaultOpen?: boolean;
}

export const BadgeDialog = ({
  badgeId,
  special,
  children,
  className,
  defaultOpen = false,
  ...props
}: BadgeDialogInterface) => {
  const [isOpen, setIsOpen] = useState(defaultOpen);

  return (
    <Dialog open={isOpen} onOpenChange={setIsOpen} {...props}>
      <DialogTrigger className={className}>{children}</DialogTrigger>
      <BadgeDetails badgeId={badgeId} special={special} setIsOpen={setIsOpen} />
    </Dialog>
  );
};
