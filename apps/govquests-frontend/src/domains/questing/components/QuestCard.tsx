import { Map as MapIcon } from "lucide-react";
import Link from "next/link";
import type React from "react";

import RewardIndicator from "@/components/RewardIndicator";
import Image from "@/components/ui/Image";
import { Quests } from "../types/questTypes";

interface QuestProps {
  quest: Quests[number];
}

const QuestCard: React.FC<QuestProps> = ({ quest }) => {
  return (
    <Link
      href={`/quests/${quest.slug}`}
      className="group flex flex-col bg-primary/10 border border-primary/20 rounded-lg overflow-hidden transition-all duration-200 hover:shadow-md hover:bg-primary/15"
    >
      <div className="relative w-full h-48 overflow-hidden">
        <div className="absolute left-0 right-0 top-0 z-10 p-3 flex justify-between items-start">
          <div className="flex items-center gap-2 px-2 py-1 bg-background/95 rounded-md backdrop-blur-sm border border-primary/20">
            <MapIcon width={16} height={16} className="text-primary/70" />
            <span className="text-xs font-medium text-primary/70 tracking-wide">
              QUEST
            </span>
          </div>
          <div className="flex gap-2">
            {quest.rewardPools.map(({ rewardDefinition: reward }) => (
              <RewardIndicator
                key={reward.type}
                reward={reward}
                className="bg-background/95 backdrop-blur-sm border border-primary/20"
              />
            ))}
          </div>
        </div>
        {quest.displayData.imageUrl ? (
          <Image
            src={quest.displayData.imageUrl}
            alt={`QuestCard ${quest.displayData.title} image`}
            className="object-cover w-full h-full transition-transform duration-200 group-hover:scale-105"
          />
        ) : (
          <div className="w-full h-full bg-primary/5" />
        )}
      </div>
      <div className="flex flex-col p-5 gap-3">
        <h3 className="font-semibold text-lg leading-tight line-clamp-2 group-hover:text-primary/90 transition-colors">
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
