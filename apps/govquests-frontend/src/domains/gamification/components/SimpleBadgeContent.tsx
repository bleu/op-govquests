import { Button } from "@/components/ui/Button";
import Link from "next/link";
import { useCallback } from "react";
import { Badge } from "../types/badgeTypes";

export const SimpleBadgeContent = ({ badge }: { badge: Badge }) => {
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

  return (
    <div className="flex flex-col gap-4">
      <h2 className="font-black text-lg w-full">Badge Unlocked!</h2>
      <span>
        You collected this badge by completing the{" "}
        {badge.badgeable.displayData.title} {badge.badgeable.__typename}.
      </span>
      <Link href={linkToBadgeable()} className="self-center">
        <Button className="px-5 w-fit">See {badge.badgeable.__typename}</Button>
      </Link>
    </div>
  );
};
