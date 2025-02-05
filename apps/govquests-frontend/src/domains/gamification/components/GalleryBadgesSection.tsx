"use client";

import { useSearchParams } from "next/navigation";
import { useFetchBadges } from "../hooks/useFetchBadges";
import { NormalBadgeCard } from "./BadgeCard";
import { BadgeDialog } from "./BadgeDialog";
import { SectionHeader } from "@/components/SectionHeader";

export const SimpleBadgesSection: React.FC = () => {
  const params = useSearchParams();
  const queryBadgeId = params.get("badgeId");

  const { data } = useFetchBadges();

  return (
    data && (
      <div className="flex flex-col items-center justify-center mx-8 w-[calc(100%-4rem)]">
        <SectionHeader
          title="Gallery"
          description="Discover all the badges you can earn."
        />
        <div className="grid xl:grid-cols-5 lg:grid-cols-4 md:grid-cols-3 sm:grid-cols-2 grid-cols-1 gap-4 w-full py-5">
          {data.badges.map((badge, index) => (
            <BadgeDialog
              defaultOpen={queryBadgeId == badge.id}
              badgeId={badge.id}
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
