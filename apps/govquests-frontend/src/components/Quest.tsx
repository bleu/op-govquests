import type { Quest as IQuest, Reward } from "@/types/quest";
import { Map as MapIcon } from "lucide-react";
import Link from "next/link";
import type React from "react";
import RewardIndicator from "./RewardIndicator";
import Image from "./ui/Image";
import { QuestsListProps } from "@/app/quests/(components)/quests-list";

interface QuestProps {
  quest: QuestsListProps["quests"][number];
}

const Quest: React.FC<QuestProps> = ({ quest }) => {
  return (
    <>
      <Link
        href={`/quests/${quest.id}`}
        className="flex flex-col bg-primary rounded-lg hover:bg-primary/70 transition"
      >
        <div className="relative w-full h-40 rounded-t-lg overflow-hidden">
          <div className="absolute right-3 top-3">
            {quest.rewards.map((reward) => (
              <RewardIndicator key={reward.type} reward={reward} />
            ))}
          </div>
          {!!quest.displayData.imageUrl && (
            <Image
              src={quest.displayData.imageUrl}
              alt={`Quest ${quest.displayData.title} image`}
              className="object-cover w-full h-full"
            />
          )}{" "}
        </div>
        <div className="flex flex-col pl-6 pr-4 pb-6">
          <div className="flex items-center gap-3 mt-2 mb-1 min-h-16">
            <MapIcon width={25} height={25} />
            <h3 className="font-bold text-lg line-clamp-2">
              {quest.displayData.title}
            </h3>
          </div>
          <p className="text-md line-clamp-3">{quest.displayData.intro}</p>
        </div>
      </Link>
    </>
  );
};

export default Quest;
