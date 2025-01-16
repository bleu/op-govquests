import {
  DialogContent,
  DialogDescription,
  DialogHeader,
} from "@/components/ui/dialog";
import { BadgeCard } from "./BadgeCard";
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
          <div className="w-[190px]">
            <BadgeCard badgeId={badgeId} isCompleted={true} />
          </div>
          {special ? (
            <SpecialBadgeContent badgeId={badgeId} />
          ) : (
            <SimpleBadgeContent badgeId={badgeId} />
          )}
        </DialogDescription>
      </DialogHeader>
    </DialogContent>
  );
};
