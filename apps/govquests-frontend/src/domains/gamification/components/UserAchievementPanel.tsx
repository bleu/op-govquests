"use client";

import { IndicatorPill } from "@/components/IndicatorPill";
import { useUserProfile } from "@/hooks/useUserProfile";
import Image from "next/image";
import { ComponentProps } from "react";
import { useCompleteUserInfo } from "../hooks/useCompleteUserInfo";

export const UserAchievementPanel = () => {
  const { data: userProfile } = useUserProfile();
  const { data: userData } = useCompleteUserInfo();

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
        {userData && (
          <>
            <InfoLabel label="Quests">
              {userData.currentUser.userQuests.length}/10
            </InfoLabel>
            <InfoLabel label="Ranking">
              #{userData.currentUser.gameProfile.rank}
            </InfoLabel>
            <InfoLabel label="Points">
              {userData.currentUser.gameProfile.score}
            </InfoLabel>
            <InfoLabel label="Collection">
              {userData.currentUser.userBadges.length} Badges
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
            <p className="font-bold text-sm">{userProfile.name}</p>
          </div>
        </div>
        <IndicatorPill className="px-8 min-w-48 h-[26px]">
          {userData && userData.currentUser.gameProfile.tier.displayData.title}
        </IndicatorPill>
      </div>
    </div>
  );
};

interface InfoLabelProps extends ComponentProps<"p"> {
  label: string;
}

const InfoLabel = ({ label, ...props }: InfoLabelProps) => {
  return (
    <div className="flex flex-col gap-1">
      <p className="text-sm font-bold text-foreground/60">{label}</p>
      <p className="font-extrabold" {...props} />
    </div>
  );
};
