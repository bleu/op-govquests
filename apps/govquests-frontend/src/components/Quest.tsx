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
    <div className="flex flex-col items-center">
      <Image src={imageSrc} alt={altText} width={100} height={100} />
      <h3>{title}</h3>
      <div className="flex flex-col items-center">
        <span>
          {points} {rewardType}
        </span>
        <button type="button" onClick={onStart}>
          Start
        </button>
      </div>
    </div>
  );
};

export default Quest;
