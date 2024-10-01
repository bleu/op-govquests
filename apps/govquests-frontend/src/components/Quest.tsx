import Image from "next/image";
import type React from "react";

interface QuestProps {
  imageSrc: string;
  altText: string;
  title: string;
  points: number;
  rewardType: string;
  onStart: () => void;
}

const Quest: React.FC<QuestProps> = ({
  imageSrc,
  altText,
  title,
  points,
  rewardType,
  onStart,
}) => {
  return (
    <div className="flex flex-col bg-red-300 rounded-lg">
      <div className="relative w-full border border-black h-36">
        <Image src={imageSrc} alt={altText} layout="fill" objectFit="cover" />
      </div>
      <div className="flex flex-col p-4">
        <h3>{title}</h3>
        <span className="bg-white self-start py-1 px-2 mt-1 mb-5 rounded text-sm">
          {points} {rewardType}
        </span>
        <button type="button" onClick={onStart} className="bg-white rounded-lg">
          Start
        </button>
      </div>
    </div>
  );
};

export default Quest;
