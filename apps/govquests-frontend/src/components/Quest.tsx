import type { Reward } from "@/types/quest";
import Link from "next/link";
import type React from "react";
import Image from "./Image";

interface QuestProps {
  id: string;
  imageSrc: string;
  altText: string;
  title: string;
  rewards: Reward[];
  status: string;
}

const Quest: React.FC<QuestProps> = ({
  id,
  imageSrc,
  altText,
  title,
  rewards,
  status,
}) => {
  return (
    <div className="flex flex-col bg-red-300 rounded-lg">
      <div className="relative w-full border border-black h-36">
        <Image
          src={imageSrc}
          alt={altText}
          className="object-cover w-full h-full"
        />
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
        <Link
          href={id}
          className="bg-white py-1 rounded-lg hover:bg-zinc-100 text-center"
        >
          {status}
        </Link>
      </div>
    </div>
  );
};

export default Quest;
