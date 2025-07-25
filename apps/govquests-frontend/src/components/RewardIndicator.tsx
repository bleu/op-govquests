import type { Rewards } from "@/domains/questing/types/questTypes";
import Image from "next/image";
import type React from "react";
import { IndicatorPill } from "./IndicatorPill";
import { cn } from "@/lib/utils";

interface RewardIndicator {
  reward: Pick<Rewards[number]["rewardDefinition"], "amount" | "type">;
  className?: string;
}

const RewardIndicator: React.FC<RewardIndicator> = ({ reward, className }) => {
  return (
    <IndicatorPill
      className={cn(
        className,
        reward.type === "Token" &&
          "!bg-gradient-to-r !from-[#7D72F5] !to-[#B84577]",
      )}
    >
      {reward.amount} {reward.type === "Token" ? "OP Reward" : reward.type}
    </IndicatorPill>
  );
};

export default RewardIndicator;
