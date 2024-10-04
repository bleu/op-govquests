import type { Reward } from "@/types/quest";
import { Map as MapIcon } from "lucide-react";
import Link from "next/link";
import type React from "react";
import Image from "./Image";
import RewardIndicator from "./RewardIndicator";

interface QuestProps {
  id: string;
  imageSrc: string;
  title: string;
  intro: string;
  rewards: Reward[];
}

const Quest: React.FC<QuestProps> = ({
  id,
  imageSrc,
  title,
  intro,
  rewards,
}) => {
  return (
    <>
      <Link
        href={`/quests/${id}`}
        className="flex flex-col bg-primary rounded-lg hover:bg-primary/70 transition"
      >
        <div className="relative w-full h-40 rounded-t-lg overflow-hidden">
          <div className="absolute right-3 top-3">
            {rewards.map((reward) => (
              <RewardIndicator key={reward.type} reward={reward} />
            ))}
          </div>
          <Image
            src={
              imageSrc ||
              "https://file.coinexstatic.com/2023-11-16/BB3FDB00283C55B4C36B94CFAC0C3271.png"
            }
            alt={`Quest ${title} image`}
            className="object-cover w-full h-full"
          />
        </div>
        <div className="flex flex-col pl-6 pr-4 pb-6">
          <div className="flex items-center gap-3 mt-2 mb-1 min-h-16">
            <MapIcon width={25} height={25} />
            <h3 className="font-bold text-lg line-clamp-2">{title}</h3>
          </div>
          <p className="text-md line-clamp-3">{intro}</p>
        </div>
      </Link>
    </>
  );
};

export default Quest;
