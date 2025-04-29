import { Dialog, DialogTrigger } from "@/components/ui/dialog";
import type { DialogProps } from "@radix-ui/react-dialog";
import { BadgeDetails } from "./BadgeDetails";
import { useState } from "react";

interface BadgeDialogInterface extends DialogProps {
  badgeId: string;
  children: React.ReactNode;
  special?: boolean;
  className?: string;
}

export const BadgeDialog = ({
  badgeId,
  special,
  children,
  className,
  ...props
}: BadgeDialogInterface) => {
  const [isOpen, setIsOpen] = useState(false);

  return (
    <Dialog open={isOpen} onOpenChange={setIsOpen} {...props}>
      <DialogTrigger className={className}>{children}</DialogTrigger>
      <BadgeDetails badgeId={badgeId} special={special} setIsOpen={setIsOpen} />
    </Dialog>
  );
};
