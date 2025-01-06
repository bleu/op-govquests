import Link from "next/link";
import type React from "react";

import RewardIndicator from "@/components/RewardIndicator";
import Image from "@/components/ui/Image";
import { Quests } from "../types/questTypes";
import { IndicatorPill } from "@/components/IndicatorPill";
import { cn } from "@/lib/utils";

interface QuestProps {
  quest: Quests[number];
}

const QuestCard: React.FC<QuestProps> = ({ quest }) => {
  const isCompleted = quest.status == "completed";

  return (
    <Link href={`/quests/${quest.slug}`}>
      <div className="rounded-lg overflow-hidden group transition-all duration-300 hover:shadow-lg">
        <div
          className={cn(
            "relative bg-secondary flex justify-center items-center p-6",
            isCompleted && "bg-gradient-to-b from-[#80F2FF] to-[#A1E0D2]",
          )}
        >
          <div className="w-full text-center text-primary-foreground font-bold text-lg py-3 bg-primary border border-primary-foreground shadow-[1px_1px_0px_0px_#000000] rounded-lg transition-all duration-300 group-hover:shadow-[2px_2px_0px_0px_#000000] group-hover:scale-105">
            {quest.displayData.title}
          </div>
          <IndicatorPill className="absolute bottom-0 left-1/2 -translate-x-1/2 translate-y-1/2">
            {isCompleted
              ? "Completed"
              : quest.rewardPools[0].rewardDefinition.amount + " points"}
          </IndicatorPill>
        </div>
        <div className="bg-background/60 h-full p-7">
          <p className="text-sm text-foreground line-clamp-4">
            <span
              dangerouslySetInnerHTML={{
                __html: quest.displayData.intro || "",
              }}
            />
          </p>
        </div>
      </div>
    </Link>
  );
};

export default QuestCard;
