"use client";

import { SectionHeader } from "@/components/SectionHeader";
import { useUserInfo } from "../hooks/useUserInfo";
import { NormalBadgeCard, SpecialBadgeCard } from "./BadgeCard";
import { cn } from "@/lib/utils";
import type { ComponentProps } from "react";

interface UserBadgesCollectionProps extends ComponentProps<"div"> {
  userId: string;
}

export const UserBadgesCollection = ({
  userId,
  className,
  ...props
}: UserBadgesCollectionProps) => {
  const { data } = useUserInfo(userId);

  return (
    <div className="flex flex-col py-7 overflow-visible text-foreground">
      <div className="px-7">
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
          data?.user.userBadges.map(({ badge }) => {
            if (badge.__typename === "Badge")
              return (
                <NormalBadgeCard
                  badgeId={badge.id}
                  key={badge.id}
                  withTitle={true}
                  header={`${badge.badgeable.__typename} BADGE #${badge.displayData.sequenceNumber}`}
                  revealIncomplete
                  scaleDisabled
                />
              );
            return (
              <SpecialBadgeCard
                badgeId={badge.id}
                key={badge.id}
                withTitle={true}
                header={`SPECIAL BADGE #${badge.displayData.sequenceNumber}`}
                revealIncomplete
                scaleDisabled
              />
            );
          })
        ) : (
          <div className="w-full col-span-4 mt-4 text-foreground/80">
            This user hasn't collected any badges yet.
          </div>
        )}
      </div>
    </div>
  );
};
