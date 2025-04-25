"use client";

import { SectionHeader } from "@/components/SectionHeader";
import { useUserInfo } from "../hooks/useUserInfo";
import { NormalBadgeCard, SpecialBadgeCard } from "./BadgeCard";
import { cn } from "@/lib/utils";
import type { ComponentProps } from "react";
import Link from "next/link";

interface UserBadgesCollectionProps extends ComponentProps<"div"> {
  userId: string;
  headerClassName?: string;
}

export const UserBadgesCollection = ({
  userId,
  className,
  headerClassName,
  ...props
}: UserBadgesCollectionProps) => {
  const { data } = useUserInfo(userId);

  return (
    <div className="flex flex-col py-7 overflow-visible text-foreground">
      <div className={headerClassName}>
        <SectionHeader title="Badges Collection" />
      </div>
      <div
        className={cn(
          "grid lg:grid-cols-4 md:grid-cols-3 grid-cols-2 pt-4 h-64 overflow-y-scroll custom-scrollbar pr-4 pl-6 mr-1",
          className,
        )}
        {...props}
      >
        {data?.user.userBadges.length ? (
          data?.user.userBadges.map(({ badge }) => (
            <Link
              href={`/achievements?badgeId=${badge.id}`}
              key={badge.id}
              className="hover:scale-105 transition duration-300"
            >
              {badge.__typename === "Badge" ? (
                <NormalBadgeCard
                  badgeId={badge.id}
                  key={badge.id}
                  withTitle={true}
                  header={`${badge.badgeable.__typename} BADGE #${badge.displayData.sequenceNumber}`}
                  revealIncomplete
                  scaleDisabled
                />
              ) : (
                <SpecialBadgeCard
                  badgeId={badge.id}
                  key={badge.id}
                  withTitle={true}
                  header={`SPECIAL BADGE #${badge.displayData.sequenceNumber}`}
                  revealIncomplete
                  scaleDisabled
                />
              )}
            </Link>
          ))
        ) : (
          <div className="w-full col-span-4 mt-4 text-foreground/80">
            This user hasn't collected any badges yet.
          </div>
        )}
      </div>
    </div>
  );
};
