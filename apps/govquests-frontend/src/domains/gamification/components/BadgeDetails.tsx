import { Button } from "@/components/ui/Button";
import {
  DialogContent,
  DialogDescription,
  DialogHeader,
} from "@/components/ui/dialog";
import Link from "next/link";
import { useCallback } from "react";
import { useFetchBadge } from "../hooks/useFetchBadge";
import { BadgeCard } from "./BadgeCard";

export const BadgeDetails = ({ badgeId }: { badgeId: string }) => {
  const { data } = useFetchBadge(badgeId);

  const linkToBadgeable = useCallback(() => {
    if (!data) return "";
    switch (data.badge.badgeable.__typename) {
      case "Quest":
        return `/quests/${data.badge.badgeable.slug}`;
      case "Track":
        return `/quests?trackId=${data.badge.badgeable.id}`;
      default:
        return "";
    }
  }, [data]);

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
                {data.badge.badgeable.displayData.title}{" "}
                {data.badge.badgeable.__typename}.
              </span>
              <Link href={linkToBadgeable()}>
                <Button className="px-5 w-fit self-center">
                  See {data.badge.badgeable.__typename}
                </Button>
              </Link>
            </div>
          </DialogDescription>
        </DialogHeader>
      </DialogContent>
    )
  );
};
