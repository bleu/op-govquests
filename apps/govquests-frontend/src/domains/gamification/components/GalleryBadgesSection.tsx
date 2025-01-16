"use client";

import { Dialog, DialogTrigger } from "@/components/ui/dialog";
import { useSearchParams } from "next/navigation";
import { useFetchBadges } from "../hooks/useFetchBadges";
import { BadgeCard } from "./BadgeCard";
import { BadgeDetails } from "./BadgeDetails";

export const SimpleBadgesSection: React.FC = () => {
  const params = useSearchParams();
  const queryBadgeId = params.get("badgeId");

  const { data } = useFetchBadges(false);

  return (
    data && (
      <div className="flex flex-col items-center justify-center mx-8 w-[calc(100%-4rem)]">
        <div className="flex flex-col gap-3 pb-4 border-b border-foreground/20 w-full">
          <h1 className="text-2xl font-bold"># Gallery</h1>
          <span className="text-xl">Discover all the badges you can earn.</span>
        </div>

        <div className="grid xl:grid-cols-5 lg:grid-cols-4 md:grid-cols-3 sm:grid-cols-2 grid-cols-1 gap-4 w-full">
          {data.badges.map((badge, index) => (
            <Dialog defaultOpen={queryBadgeId == badge.id}>
              <DialogTrigger>
                <BadgeCard
                  badgeId={badge.id}
                  isCompleted={true}
                  withTitle
                  header={`BADGE #${index + 1}`}
                  className="w-full"
                />
              </DialogTrigger>
              <BadgeDetails badgeId={badge.id} />
            </Dialog>
          ))}
        </div>
      </div>
    )
  );
};
