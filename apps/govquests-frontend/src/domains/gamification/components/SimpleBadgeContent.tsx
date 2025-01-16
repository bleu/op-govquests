import { Button } from "@/components/ui/Button";
import Link from "next/link";
import { useCallback } from "react";
import { Badge } from "../types/badgeTypes";

export const SimpleBadgeContent = ({ badge }: { badge: Badge }) => {
  // TODO - get user badge - OP-677
  const isCompleted = true;

  const linkToBadgeable = useCallback(() => {
    switch (badge.badgeable.__typename) {
      case "Quest":
        return `/quests/${badge.badgeable.slug}`;
      case "Track":
        return `/quests?trackId=${badge.badgeable.id}`;
      default:
        return "";
    }
  }, [badge]);

  const badgeableTitle = badge.badgeable.displayData.title;
  const badgeableType = badge.badgeable.__typename;

  return (
    <div className="flex flex-col gap-4">
      <h2 className="font-black text-lg w-full">
        {isCompleted ? "Badge Unlocked!" : "This Badge is still a challenge."}
      </h2>
      <span>
        {isCompleted
          ? `You collected this badge by completing the
        ${badgeableTitle} ${badgeableType}.`
          : `Complete the ${badgeableTitle} ${badgeableType} to unlock the ${badge.displayData.title} badge and add it to your collection.`}
      </span>
      <Link href={linkToBadgeable()} className="self-center">
        <Button className="px-5 w-fit">
          {isCompleted ? "See" : "Start"} {badge.badgeable.__typename}
        </Button>
      </Link>
    </div>
  );
};
