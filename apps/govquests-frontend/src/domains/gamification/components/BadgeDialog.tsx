import { Dialog, DialogTrigger } from "@/components/ui/dialog";
import type { DialogProps } from "@radix-ui/react-dialog";
import { BadgeDetails } from "./BadgeDetails";

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
  return (
    <Dialog {...props}>
      <DialogTrigger className={className}>{children}</DialogTrigger>
      <BadgeDetails badgeId={badgeId} special={special} />
    </Dialog>
  );
};
