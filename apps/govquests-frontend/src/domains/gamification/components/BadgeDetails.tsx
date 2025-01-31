import {
  DialogContent,
  DialogDescription,
  DialogHeader,
} from "@/components/ui/dialog";
import { NormalBadgeCard, SpecialBadgeCard } from "./BadgeCard";
import { SimpleBadgeContent } from "./SimpleBadgeContent";
import { SpecialBadgeContent } from "./SpecialBadgeContent";

interface BadgeDetailsProps {
  badgeId: string;
  special?: boolean;
}

export const BadgeDetails = ({
  badgeId,
  special = false,
}: BadgeDetailsProps) => {
  return (
    <DialogContent>
      <DialogHeader>
        <DialogDescription className="flex flex-col gap-8 items-center justify-center text-foreground">
          {special ? (
            <>
              <div className="w-[190px]">
                <SpecialBadgeCard badgeId={badgeId} revealIncomplete />
              </div>
              <SpecialBadgeContent badgeId={badgeId} />
            </>
          ) : (
            <>
              <div className="w-[190px]">
                <NormalBadgeCard badgeId={badgeId} revealIncomplete />
              </div>
              <SimpleBadgeContent badgeId={badgeId} />
            </>
          )}
        </DialogDescription>
      </DialogHeader>
    </DialogContent>
  );
};
