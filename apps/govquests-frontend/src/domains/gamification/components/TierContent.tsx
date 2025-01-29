import { useFetchTier } from "../hooks/useFetchTier";
import { PodiumCard } from "./PodiumCard";

export const TierContent = ({ tierId }: { tierId: string }) => {
  const { data } = useFetchTier(tierId);

  return (
    data && (
      <div className="flex flex-col items-start border border-foreground/10 gap-9 w-full bg-background/80 p-5 rounded-[20px]">
        <div className="flex flex-col gap-6 w-full">
          <div>
            <h3 className="font-bold text-lg">{data.tier.displayData.title}</h3>
            <span className="text-sm font-normal">
              {data.tier.displayData.description}
            </span>
          </div>
          <div># Top 3</div>
          <div className="flex justify-around w-full">
            {[1, 0, 2]
              .map(
                (value) => data.tier.leaderboard.gameProfiles?.[value] || null,
              )
              .map(
                (profile) =>
                  profile && (
                    <PodiumCard
                      account={profile.profileId as `0x${string}`}
                      score={profile.score}
                      rank={profile.rank}
                    />
                  ),
              )}
          </div>
        </div>
      </div>
    )
  );
};
