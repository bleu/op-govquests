import {
  DialogContent,
  DialogDescription,
  DialogHeader,
} from "@/components/ui/dialog";
import { useFetchBadge } from "../hooks/useFetchBadge";
import { BadgeCard } from "./BadgeCard";
import { SimpleBadgeContent } from "./SimpleBadgeContent";
import { SpecialBadgeContent } from "./SpecialBadgeContent";

export const BadgeDetails = ({ badgeId }: { badgeId: string }) => {
  const { data } = useFetchBadge(badgeId);

  return (
    data && (
      <DialogContent>
        <DialogHeader>
          <DialogDescription className="flex flex-col gap-8 items-center justify-center text-foreground">
            <div className="w-[190px]">
              <BadgeCard badgeId={badgeId} isCompleted={true} />
            </div>
            {data.badge.special ? (
              <SpecialBadgeContent badge={data.badge} />
            ) : (
              <SimpleBadgeContent badge={data.badge} />
            )}
          </DialogDescription>
        </DialogHeader>
      </DialogContent>
    )
  );
};
