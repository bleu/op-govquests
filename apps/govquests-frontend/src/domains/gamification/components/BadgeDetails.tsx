import {
  DialogContent,
  DialogDescription,
  DialogHeader,
  DialogTitle,
} from "@/components/ui/dialog";
import { NormalBadgeCard, SpecialBadgeCard } from "./BadgeCard";
import { SimpleBadgeContent } from "./SimpleBadgeContent";
import { SpecialBadgeContent } from "./SpecialBadgeContent";

interface BadgeDetailsProps {
  badgeId: string;
  special?: boolean;
  setIsOpen: (isOpen: boolean) => void;
}

export const BadgeDetails = ({
  badgeId,
  special = false,
  setIsOpen,
}: BadgeDetailsProps) => {
  return (
    <DialogContent className="max-w-[500px] w-[85%] rounded-xl">
      <DialogTitle className="hidden">Badge Details</DialogTitle>
      <DialogHeader>
        <DialogDescription
          asChild
          className="flex flex-col gap-8 items-center justify-center text-foreground"
        >
          {special ? (
            <div>
              <div className="w-[190px]">
                <SpecialBadgeCard badgeId={badgeId} revealIncomplete />
              </div>
              <SpecialBadgeContent badgeId={badgeId} setIsOpen={setIsOpen} />
            </div>
          ) : (
            <div>
              <div className="w-[190px]">
                <NormalBadgeCard badgeId={badgeId} revealIncomplete />
              </div>
              <SimpleBadgeContent badgeId={badgeId} />
            </div>
          )}
        </DialogDescription>
      </DialogHeader>
    </DialogContent>
  );
};
