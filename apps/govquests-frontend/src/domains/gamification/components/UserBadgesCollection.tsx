"use client";

import { SectionHeader } from "@/components/SectionHeader";
import { useUserInfo } from "../hooks/useUserInfo";
import { NormalBadgeCard, SpecialBadgeCard } from "./BadgeCard";
import { cn } from "@/lib/utils";
import { ComponentProps } from "react";

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
    data && (
      <div className="flex flex-col p-7 text-foreground">
        <SectionHeader title="Badges Collection" />
        <div
          className={cn("grid md:grid-cols-4 grid-cols-3", className)}
          {...props}
        >
          {data.user.userBadges.length ? (
            data.user.userBadges.map(({ badge }) => {
              if (badge.__typename == "Badge")
                return (
                  <NormalBadgeCard
                    badgeId={badge.id}
                    key={badge.id}
                    withTitle={true}
                    header={`${badge.badgeable.__typename} BADGE #${badge.displayData.sequenceNumber}`}
                    revealIncomplete
                  />
                );
              else
                return (
                  <SpecialBadgeCard
                    badgeId={badge.id}
                    key={badge.id}
                    withTitle={true}
                    header={`SPECIAL BADGE #${badge.displayData.sequenceNumber}`}
                    revealIncomplete
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
    )
  );
};
