import { cn } from "@/lib/utils";
import type { Reward } from "@/types/quest";
import type React from "react";

interface RewardIndicator {
  reward: Pick<Reward, "amount" | "type">;
  className?: string;
}

const RewardIndicator: React.FC<RewardIndicator> = ({ reward, className }) => {
  return (
    <span
      className={cn(
        "bg-optimism text-optimismForeground py-1 px-2 rounded-md text-sm ml-1",
        className,
      )}
    >
      {reward.amount} {reward.type}
    </span>
  );
};

export default RewardIndicator;
