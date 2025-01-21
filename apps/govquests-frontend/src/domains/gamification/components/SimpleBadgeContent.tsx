import { Button } from "@/components/ui/Button";
import Link from "next/link";
import { useCallback } from "react";
import { useFetchBadge } from "../hooks/useFetchBadge";

export const SimpleBadgeContent = ({ badgeId }: { badgeId: string }) => {
  const { data } = useFetchBadge(badgeId);

  const isCompleted = data.badge.earnedByCurrentUser;

  const linkToBadgeable = useCallback(() => {
    if (!data?.badge) return "";
    switch (data.badge.badgeable.__typename) {
      case "Quest":
        return `/quests/${data.badge.badgeable.slug}`;
      case "Track":
        return `/quests?trackId=${data.badge.badgeable.id}`;
      default:
        return "";
    }
  }, [data]);

  const badgeableTitle = data.badge.badgeable.displayData.title;
  const badgeableType = data.badge.badgeable.__typename;

  return (
    <div className="flex flex-col gap-4">
      <h2 className="font-black text-lg w-full">
        {isCompleted ? "Badge Unlocked!" : "This Badge is still a challenge."}
      </h2>
      <span>
        {isCompleted
          ? `You collected this badge by completing the
        ${badgeableTitle} ${badgeableType}.`
          : `Complete the ${badgeableTitle} ${badgeableType} to unlock the ${data.badge.displayData.title} badge and add it to your collection.`}
      </span>
      <Link href={linkToBadgeable()} className="self-center">
        <Button className="px-5 w-fit">
          {isCompleted ? "See" : "Start"} {data.badge.badgeable.__typename}
        </Button>
      </Link>
    </div>
  );
};
