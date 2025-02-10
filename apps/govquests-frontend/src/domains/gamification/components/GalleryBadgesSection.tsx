"use client";

import { SectionHeader } from "@/components/SectionHeader";
import { useSearchParams } from "next/navigation";
import { useFetchBadges } from "../hooks/useFetchBadges";
import { NormalBadgeCard } from "./BadgeCard";
import { BadgeDialog } from "./BadgeDialog";

export const SimpleBadgesSection: React.FC = () => {
  const params = useSearchParams();
  const queryBadgeId = params.get("badgeId");

  const { data } = useFetchBadges();

  return (
    data && (
      <div className="flex flex-col items-center justify-center w-[calc(100%-3rem)] mx-6">
        <SectionHeader
          title="Gallery"
          description="Discover all the badges you can earn."
        />
        <div className="grid xl:grid-cols-5 lg:grid-cols-4 md:grid-cols-3 sm:grid-cols-2 grid-cols-1 gap-4 w-full py-5">
          {data.badges.map((badge) => (
            <BadgeDialog
              defaultOpen={queryBadgeId === badge.id}
              badgeId={badge.id}
              key={badge.id}
              className="max-w-56 sm:max-w-60 mx-auto md:mx-0"
            >
              <NormalBadgeCard
                badgeId={badge.id}
                withTitle
                header={`${badge.badgeable.__typename} BADGE #${badge.displayData.sequenceNumber}`}
                className="w-full"
              />
            </BadgeDialog>
          ))}
        </div>
      </div>
    )
  );
};
