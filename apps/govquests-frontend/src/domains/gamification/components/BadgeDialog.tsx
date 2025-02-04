import { Dialog, DialogTrigger } from "@/components/ui/dialog";
import { DialogProps } from "@radix-ui/react-dialog";
import { BadgeDetails } from "./BadgeDetails";

interface BadgeDialogInterface extends DialogProps {
  badgeId: string;
  children: React.ReactNode;
  special?: boolean;
}

export const BadgeDialog = ({
  badgeId,
  special,
  children,
  ...props
}: BadgeDialogInterface) => {
  return (
    <Dialog {...props}>
      <DialogTrigger>{children}</DialogTrigger>
      <BadgeDetails badgeId={badgeId} special={special} />
    </Dialog>
  );
};
