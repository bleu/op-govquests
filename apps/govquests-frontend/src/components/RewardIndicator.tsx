import { Rewards } from "@/domains/questing/types/questTypes";
import Image from "next/image";
import type React from "react";
import { IndicatorPill } from "./IndicatorPill";

interface RewardIndicator {
  reward: Pick<Rewards[number], "amount" | "type">;
  className?: string;
}

const RewardIndicator: React.FC<RewardIndicator> = ({ reward, className }) => {
  return (
    <IndicatorPill className={className}>
      {reward.amount}{" "}
      {reward.type == "Token" ? (
        <Image src="/opTokenIcon.svg" alt="OP Icon" width={12} height={12} />
      ) : (
        reward.type
      )}
    </IndicatorPill>
  );
};

export default RewardIndicator;
