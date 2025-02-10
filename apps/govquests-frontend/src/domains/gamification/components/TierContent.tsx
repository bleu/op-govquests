import { useEffect, useRef } from "react";
import { useFetchTier } from "../hooks/useFetchTier";
import { LeaderboardTable } from "./LeaderboardTable";
import { PodiumCard } from "./PodiumCard";
import { cn } from "@/lib/utils";

interface TierContentProps {
  tierId: string;
  isTarget?: boolean;
}

export const TierContent = ({ tierId, isTarget = false }: TierContentProps) => {
  const { data } = useFetchTier(tierId);

  const tierRef = useRef<HTMLDivElement>(null);

  useEffect(() => {
    if (isTarget && tierRef.current) {
      tierRef.current.scrollIntoView({
        behavior: "smooth",
        block: "center",
      });
    }
  }, [isTarget]);

  return (
    data && (
      <div className="flex flex-col gap-4">
        <div
          className={cn(
            "flex flex-col items-start border border-foreground/10 gap-9 w-full bg-background/80 p-5 rounded-[20px]",
            isTarget && "animate-highlight",
          )}
          ref={tierRef}
        >
          <div className="flex flex-col gap-6 w-full">
            <div>
              <h3 className="font-bold text-lg">
                {data.tier.displayData.title}
              </h3>
              <span className="text-sm font-normal">
                {data.tier.displayData.description}
              </span>
            </div>
            {data.tier.leaderboard.gameProfiles.length ? (
              <>
                <div># Top 3</div>
                <div className="grid justify-around w-full grid-cols-1 sm:grid-cols-2 md:grid-cols-3 place-items-center gap-y-4">
                  {[1, 0, 2]
                    .map(
                      (value) =>
                        data.tier.leaderboard.gameProfiles?.[value] || null,
                    )
                    .map(
                      (profile) =>
                        profile && (
                          <PodiumCard
                            profile={profile}
                            key={profile.profileId}
                          />
                        ),
                    )}
                </div>
              </>
            ) : (
              <div className="text-foreground/60">
                No one has reached this tier yet!
              </div>
            )}
          </div>
        </div>
        {data.tier.leaderboard.gameProfiles.length ? (
          <LeaderboardTable tierId={data.tier.tierId} />
        ) : null}
      </div>
    )
  );
};
