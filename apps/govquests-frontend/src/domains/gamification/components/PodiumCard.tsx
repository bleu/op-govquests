import { useUserProfile } from "@/hooks/useUserProfile";
import { cn, koulen } from "@/lib/utils";
import Image from "next/image";
import Link from "next/link";
import type { FC } from "react";
import type { TIER_QUERY } from "../graphql/tierQuery";
import type { ResultOf } from "gql.tada";

interface PodiumCardProps {
  profile: ResultOf<
    typeof TIER_QUERY
  >["tier"]["leaderboard"]["gameProfiles"][number];
}

export const PodiumCard = ({ profile }: PodiumCardProps) => {
  const { data } = useUserProfile(profile.user.address as `0x${string}`);

  return (
    <Link href={`/leaderboard/${profile.user.id}`}>
      <div className="rounded-[20px] w-fit p-5 border border-foreground/10 bg-gradient-to-b from-black/5 to-black/25 px-4 py-6 flex gap-2 items-center hover:shadow-[0px_4px_6px_0px_#00000040] transition-all duration-300 hover:scale-105">
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
            <TrophyIcon rank={profile.rank} className="mb-1" />
            {profile.score} points
          </span>
        </div>
      </div>
    </Link>
  );
};

interface TrophyIconProps {
  rank?: number;
  size?: number;
  className?: string;
}

export const TrophyIcon: FC<TrophyIconProps> = ({
  rank = 2,
  size = 18,
  className = "",
}) => {
  const height = (size * 16) / 18;

  const podiumColors = {
    1: "#EED300",
    2: "#9C9C9C",
    3: "#C37F26",
  };

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
        fill={podiumColors[rank]}
      />
    </svg>
  );
};
