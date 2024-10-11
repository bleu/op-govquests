import { Rewards } from "@/domains/questing/types/questTypes";
import { cn } from "@/lib/utils";
import type React from "react";

interface RewardIndicator {
  reward: Pick<Rewards[number], "amount" | "type">;
  className?: string;
}

const RewardIndicator: React.FC<RewardIndicator> = ({ reward, className }) => {
  return (
    <span
      className={cn(
        "bg-primary text-primaryForeground py-1 px-2 rounded-md text-sm ml-1",
        className,
      )}
    >
      {reward.amount} {reward.type}
    </span>
  );
};

export default RewardIndicator;
