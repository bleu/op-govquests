"use client";

import { IndicatorPill } from "@/components/IndicatorPill";
import { useUserProfile } from "@/hooks/useUserProfile";
import { ResultOf } from "gql.tada";
import Image from "next/image";
import { ComponentProps, useEffect } from "react";
import { CURRENT_USER_QUERY, USER_QUERY } from "../graphql/userQuery";
import { useCurrentUserInfo, useUserInfo } from "../hooks/useUserInfo";
import Link from "next/link";

export const CurrentUserAchievementPanel = () => {
  const { data, isSuccess, isError, isLoading } = useCurrentUserInfo();

  if (isError) {
    return null;
  }

  if (isSuccess) {
    return <UserAchievementPanel user={data?.currentUser} isFromCurrentUser />;
  }
};

export const ThirdUserAchievementPanel = ({ userId }: { userId: string }) => {
  const { data } = useUserInfo(userId);

  return <UserAchievementPanel user={data?.user} />;
};

interface UserAchievementPanelProps {
  user:
    | ResultOf<typeof USER_QUERY>["user"]
    | ResultOf<typeof CURRENT_USER_QUERY>["currentUser"];
  isFromCurrentUser?: boolean;
}

export const UserAchievementPanel = ({
  user,
  isFromCurrentUser = false,
}: UserAchievementPanelProps) => {
  const { data: userProfile } = useUserProfile(user?.address as `0x${string}`);

  return (
    <div className="w-full h-80 overflow-hidden rounded-[20px] relative">
      <Image
        src="backgrounds/first_tier.svg"
        alt="tier_background"
        width={100}
        height={100}
        className="object-cover size-full"
      />
      <div className="absolute bottom-0 bg-background/90 w-full rounded-[20px] h-20 text-white flex flex-row justify-around items-center border-foreground/10 border">
        {user && (
          <>
            <InfoLabel label="Quests" href={isFromCurrentUser && "/quests"}>
              {user.userQuests.length}/10
            </InfoLabel>
            <InfoLabel
              label="Ranking"
              href={
                isFromCurrentUser &&
                `/leaderboard?tab=myTier&rank=${user.gameProfile.rank}`
              }
            >
              #{user.gameProfile.rank}
            </InfoLabel>
            <InfoLabel
              label="Points"
              href={
                isFromCurrentUser &&
                `/leaderboard?tab=myTier&rank=${user.gameProfile.rank}`
              }
            >
              {user.gameProfile.score}
            </InfoLabel>
            <InfoLabel label="Multiplier">
              {user.gameProfile.tier.multiplier}x
            </InfoLabel>
            <InfoLabel
              label="Collection"
              href={isFromCurrentUser && "/achievements"}
            >
              {user.userBadges.length} Badges
            </InfoLabel>
          </>
        )}
      </div>
      <div className="flex flex-col gap-0 absolute bottom-[70px] left-1/2 -translate-x-1/2 items-center">
        <div className="w-full px-5">
          <div className="max-w-fit mx-auto px-5 bg-background/80 pb-1 pt-3 flex flex-col gap-2 border-foreground/10 border rounded-t-2xl overflow-hidden items-center">
            <div className="size-20 border flex flex-col justify-center rounded-full">
              {userProfile.avatarUrl && (
                <Image
                  width={200}
                  height={200}
                  src={userProfile.avatarUrl}
                  alt="opSun"
                  className="size-full object-contain rounded-full"
                  unoptimized
                />
              )}
            </div>
            <p className="font-bold text-sm text-foreground">
              {userProfile.name}
            </p>
          </div>
        </div>
        <IndicatorPill className="px-8 min-w-48 h-[26px]">
          {user && user.gameProfile.tier.displayData.title}
        </IndicatorPill>
      </div>
    </div>
  );
};

interface InfoLabelProps extends ComponentProps<"p"> {
  label: string;
  href?: string;
}

const InfoLabel = ({ label, href, ...props }: InfoLabelProps) => {
  const infoLabelComponent = (
    <div className="flex flex-col gap-1">
      <p className="text-sm font-bold text-foreground/60">{label}</p>
      <p className="font-extrabold" {...props} />
    </div>
  );

  if (href) {
    return (
      <Link href={href} className="hover:scale-105 transition duration-300">
        {infoLabelComponent}
      </Link>
    );
  }
  return infoLabelComponent;
};
