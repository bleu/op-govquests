import Link from "next/link";
import type React from "react";

import { IndicatorPill } from "@/components/IndicatorPill";
import { cn, koulen } from "@/lib/utils";
import { Quests } from "../types/questTypes";
import { Tracks } from "../types/trackTypes";

interface QuestProps {
  quest: Quests[number];
  backgroundGradient: Tracks[number]["displayData"]["backgroundGradient"];
}

const QuestCard: React.FC<QuestProps> = ({ quest, backgroundGradient }) => {
  const status = quest.userQuests?.[0]?.status || "unstarted";
  const isCompleted = status === "completed";

  return (
    <Link href={`/quests/${quest.slug}`}>
      <div className="rounded-lg overflow-hidden group transition-all duration-300 hover:shadow-lg h-full flex flex-col">
        <div
          className={cn(
            "relative bg-secondary flex justify-center h-full items-center p-6 bg-gradient-to-b from-[var(--from-color)] to-[var(--to-color)]",
            !isCompleted && "grayscale",
          )}
          style={
            {
              "--from-color": backgroundGradient.fromColor,
              "--to-color": backgroundGradient.toColor,
            } as React.CSSProperties
          }
        >
          <div
            className={cn(
              "w-full text-center p-3 text-primary-foreground font-medium text-xl bg-primary border border-primary-foreground shadow-[1px_1px_0px_0px_#000000] rounded-lg transition-all duration-300 group-hover:shadow-[2px_2px_0px_0px_#000000] group-hover:scale-105",
              koulen.className,
            )}
          >
            {quest.displayData.title}
          </div>
          <IndicatorPill className="absolute bottom-0 left-1/2 -translate-x-1/2 translate-y-1/2">
            {isCompleted
              ? "Completed"
              : quest.rewardPools[0].rewardDefinition.amount + " points"}
          </IndicatorPill>
        </div>
        <div className="bg-background/60 p-7">
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
