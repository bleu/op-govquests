import { Map as MapIcon } from "lucide-react";
import Link from "next/link";
import type React from "react";

import RewardIndicator from "@/components/RewardIndicator";
import Image from "@/components/ui/Image";
import { Quests } from "../types/questTypes";

interface QuestProps {
  quest: Quests[number];
}

const QuestCard2: React.FC<QuestProps> = ({ quest }) => {
  console.log(quest);
  return (
    <Link
      href={`/quests/${quest.slug}`}
      className="group flex flex-col bg-primary/10 border border-primary/20 rounded-lg overflow-hidden transition-all duration-200 hover:shadow-md hover:bg-primary/15"
    >
      <div className="relative w-full h-48 overflow-hidden">
        <div className="absolute w-21 left-0 right-0 top-0 z-10 p-3 flex flex-col gap-3 justify-between items-start">
          {quest.rewardPools
            .toReversed()
            .map(({ rewardDefinition: reward }) => (
              <RewardIndicator
                key={reward.type}
                reward={reward}
                className="bg-primary/50 text-white backdrop-blur-sm border border-primary/20 "
              />
            ))}
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
      <div className="flex flex-col p-7 gap-4">
        <h3 className="font-semibold text-lg leading-tight line-clamp-2 group-hover:text-primary/90 transition-colors flex gap-2">
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

const QuestCard: React.FC<QuestProps> = ({ quest }) => {
  const isCompleted = quest.status == "completed";

  return (
    <Link href={`/quests/${quest.slug}`}>
      <div className="rounded-lg h-56 overflow-hidden group transition-all duration-300 hover:shadow-lg">
        <div className="bg-secondary h-[40%] flex justify-center items-center px-6">
          <div className="w-full text-center text-primary-foreground font-bold text-lg py-3 bg-primary border border-primary-foreground shadow-[1px_1px_0px_0px_#000000] rounded-lg transition-all duration-300 group-hover:shadow-[2px_2px_0px_0px_#000000] group-hover:scale-105">
            {quest.displayData.title}
          </div>
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
