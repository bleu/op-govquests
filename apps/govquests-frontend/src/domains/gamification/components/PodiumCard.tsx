import { useUserProfile } from "@/hooks/useUserProfile";
import { cn, koulen } from "@/lib/utils";
import { Trophy } from "lucide-react";
import Image from "next/image";
import { FC } from "react";

interface PodiumCardProps {
  account: `0x${string}`;
  score: number;
  rank: number;
}

export const PodiumCard = ({ account, score, rank }: PodiumCardProps) => {
  const { data } = useUserProfile(account);

  const podiumColors = {
    1: "#EED300",
    2: "#9C9C9C",
    3: "#C37F26",
  };

  return (
    <div className="rounded-[20px] p-5 border border-foreground/10 bg-gradient-to-b from-black/5 to-black/25 px-4 py-6 flex gap-2 items-center">
      {data && (
        <Image
          src={data.avatarUrl}
          alt="avatar"
          width={52}
          height={52}
          unoptimized
          className="rounded-full self-center pb-1"
        />
      )}
      <div className="flex flex-col gap-1">
        <span>{data?.name}</span>
        <span
          className={cn("text-lg flex gap-2 items-center", koulen.className)}
        >
          <TrophyIcon color={podiumColors[rank]} className="mb-1" />
          {score} points
        </span>
      </div>
    </div>
  );
};

interface TrophyIconProps {
  color?: string;
  size?: number;
  className?: string;
}

export const TrophyIcon: FC<TrophyIconProps> = ({
  color = "#9C9C9C",
  size = 18,
  className = "",
}) => {
  const height = (size * 16) / 18;

  return (
    <svg
      width={size}
      height={height}
      viewBox="0 0 18 16"
      fill="none"
      xmlns="http://www.w3.org/2000/svg"
      className={className}
    >
      <path
        d="M12.3333 0.5H3.99996V2.16667H0.666626V10.5H5.66663V2.16667H12.3333V10.5H17.3333V2.16667H14V0.5H12.3333ZM15.6666 3.83333V8.83333H14V3.83333H15.6666ZM3.99996 8.83333H2.33329V3.83333H3.99996V8.83333ZM14 10.5H3.99996V12.1667H14V10.5ZM8.16663 12.1667H9.83329V13.8333H12.3333V15.5H5.66663V13.8333H8.16663V12.1667Z"
        fill={color}
      />
    </svg>
  );
};
