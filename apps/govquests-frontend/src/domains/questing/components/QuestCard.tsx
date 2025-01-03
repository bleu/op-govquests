import Link from "next/link";
import type React from "react";

import RewardIndicator from "@/components/RewardIndicator";
import Image from "@/components/ui/Image";
import { Quests } from "../types/questTypes";
import { cn } from "@/lib/utils";

interface QuestProps {
  quest: Quests[number];
}

const QuestCard: React.FC<QuestProps> = ({ quest }) => {
  const status = quest.userQuests?.[0]?.status || "unstarted";
  const disabled = status === "completed";

  const peelClassName =
    "bg-primary/50 text-white backdrop-blur-sm border border-primary/20";

  return (
    <Link
      href={`/quests/${quest.slug}`}
      className={cn(
        "group flex flex-col bg-primary/10 border border-primary/20 rounded-lg overflow-hidden transition-all duration-200",
        disabled ? "cursor-default" : "hover:shadow-md hover:bg-primary/15",
      )}
    >
      <div className="relative w-full h-48 overflow-hidden">
        <div className="absolute w-21 left-0 right-0 top-0 z-10 p-3 flex flex-col gap-3 justify-between items-start">
          {disabled ? (
            <span
              className={cn(
                "bg-secondary font-normal py-1 px-2 rounded-md text-sm ml-1 flex gap-1 p-auto w-21",
                peelClassName,
              )}
            >
              Completed
            </span>
          ) : (
            quest.rewardPools
              .toReversed()
              .map(({ rewardDefinition: reward }) => (
                <RewardIndicator
                  key={reward.type}
                  reward={reward}
                  className={peelClassName}
                />
              ))
          )}
        </div>
        {quest.displayData.imageUrl ? (
          <Image
            src={quest.displayData.imageUrl}
            alt={`QuestCard ${quest.displayData.title} image`}
            className={cn(
              "object-cover w-full h-full transition-transform duration-200",
              !disabled && "group-hover:scale-105",
            )}
          />
        ) : (
          <div className="w-full h-full bg-primary/5" />
        )}
      </div>
      <div className={cn("flex flex-col p-7 gap-4", disabled && "opacity-60")}>
        <h3
          className={cn(
            "font-semibold text-lg leading-tight line-clamp-2 transition-colors flex gap-2",
            !disabled && "group-hover:text-primary/90",
          )}
        >
          {quest.displayData.title}
        </h3>
        <p className="text-sm text-foreground/70 line-clamp-3">
          <span
            dangerouslySetInnerHTML={{
              __html: quest.displayData.intro || "",
            }}
          />
        </p>
      </div>
    </Link>
  );
};

export default QuestCard;
