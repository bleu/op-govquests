import { Rewards } from "@/domains/questing/types/questTypes";
import { cn } from "@/lib/utils";
import Image from "next/image";
import type React from "react";

interface RewardIndicator {
  reward: Pick<Rewards[number], "amount" | "type">;
  className?: string;
}

const RewardIndicator: React.FC<RewardIndicator> = ({ reward, className }) => {
  return (
    <span
      className={cn(
        "bg-secondary font-normal py-1 px-4 rounded-md text-sm ml-1 flex gap-1 p-auto w-21",
        className,
      )}
    >
      {reward.amount} {reward.type}
    </span>
  );
};

export default RewardIndicator;
