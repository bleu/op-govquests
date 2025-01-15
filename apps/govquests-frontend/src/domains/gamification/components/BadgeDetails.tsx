import { Button } from "@/components/ui/Button";
import {
  DialogContent,
  DialogDescription,
  DialogHeader,
} from "@/components/ui/dialog";
import { useFetchBadge } from "../hooks/useFetchBadge";
import { BadgeCard } from "./BadgeCard";

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
            <div className="flex flex-col gap-4">
              <h2 className="font-black text-lg w-full">Badge Unlocked!</h2>
              <span>
                You collected this badge by completing the{" "}
                {data.badge.displayData.source}.
              </span>
              <Button className="px-5 w-fit self-center">
                See {data.badge.displayData.source}
              </Button>
            </div>
          </DialogDescription>
        </DialogHeader>
      </DialogContent>
    )
  );
};
