import type { Reward } from "@/types/quest";
import Image from "next/image";
import type React from "react";

interface QuestProps {
  imageSrc: string;
  altText: string;
  title: string;
  rewards: Reward[];
  status: string;
  onClick: () => void;
}

const Quest: React.FC<QuestProps> = ({
  imageSrc,
  altText,
  title,
  rewards,
  status,
  onClick,
}) => {
  return (
    <div className="flex flex-col bg-red-300 rounded-lg">
      <div className="relative w-full border border-black h-36">
        <Image src={imageSrc} alt={altText} layout="fill" objectFit="cover" />
      </div>
      <div className="flex flex-col p-4">
        <h3>{title}</h3>
        <div className="flex gap-2">
          {rewards.map((reward) => (
            <span
              key={reward.type}
              className="bg-white self-start py-1 px-2 mt-1 mb-5 rounded text-sm"
            >
              {reward.amount} {reward.type}
            </span>
          ))}
        </div>
        <button
          type="button"
          onClick={onClick}
          className="bg-white py-1 rounded-lg hover:bg-zinc-100"
        >
          {status}
        </button>
      </div>
    </div>
  );
};

export default Quest;
