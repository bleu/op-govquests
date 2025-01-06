import RewardIndicator from "@/components/RewardIndicator";
import { cn } from "@/lib/utils";
import { Quest, Quests } from "../types/questTypes";

interface QuestPeelsProps {
  quest: Quest | Quests[number];
  variant: "ghost" | "primary";
  className?: string;
}

export const QuestPeels = ({ quest, variant, className }: QuestPeelsProps) => {
  const status = quest.userQuests?.[0]?.status || "unstarted";
  const disabled = status === "completed";

  const peelClassName = cn(
    "text-white backdrop-blur-sm border",
    variant == "primary"
      ? "bg-primary/50 bg-primary/50 text-white border-primary/20"
      : "text-black/80 bg-background",
  );

  return (
    <div className={cn("flex gap-1", className)}>
      {disabled ? (
        <span
          className={cn(
            "bg-secondary font-normal py-1 px-4 rounded-md text-sm ml-1 flex gap-1 p-auto w-21",
            peelClassName,
          )}
        >
          Completed
        </span>
      ) : (
        quest.rewardPools.map(({ rewardDefinition: reward }) => (
          <RewardIndicator
            key={reward.type}
            reward={reward}
            className={peelClassName}
          />
        ))
      )}
    </div>
  );
};
