"use client";

import { IndicatorPill } from "@/components/IndicatorPill";
import { Button } from "@/components/ui/Button";
import { useToast } from "@/hooks/use-toast";
import { useUserProfile } from "@/hooks/useUserProfile";
import type { ResultOf } from "gql.tada";
import { ArrowUpRight } from "lucide-react";
import Image from "next/image";
import Link from "next/link";
import type { ComponentProps } from "react";
import type { CURRENT_USER_QUERY, USER_QUERY } from "../graphql/userQuery";
import { useCurrentUserInfo, useUserInfo } from "../hooks/useUserInfo";
import { useFetchQuests } from "@/domains/questing/hooks/useFetchQuests";
import { ConditionalWrapper } from "@/components/ui/ConditionalWrapper";

export const CurrentUserAchievementPanel = () => {
  const { data, isSuccess, isError } = useCurrentUserInfo();

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
  const { data: questsData } = useFetchQuests();

  const { toast } = useToast();

  const handleShareProfile = async () => {
    try {
      await navigator.clipboard.writeText(
        `${window.location.origin}/leaderboard/${user.id}`,
      );
      toast({
        title: "Profile link copied to clipboard.",
      });
    } catch (err) {
      console.error("Failed to copy text: ", err);
    }
  };

  return (
    <div className="w-full overflow-hidden rounded-[20px] relative flex flex-col">
      {isFromCurrentUser && (
        <Button
          size="sm"
          variant="outline"
          onClick={handleShareProfile}
          className="absolute top-4 right-7 bg-background/90 border-primary/10 h-fit py-1 hover:bg-background/90"
        >
          <ArrowUpRight />
          Share
        </Button>
      )}
      {user && (
        <Image
          src={
            user.gameProfile.tier.imageUrl || "/backgrounds/OP_BLEU_TIER_01.png"
          }
          alt="tier_background"
          width={1000}
          height={1000}
          className="absolute object-cover size-full -z-10"
        />
      )}
      <div className="mt-52 bg-background/90 rounded-[20px] py-4 text-white grid grid-cols-2 gap-y-2 place-items-center sm:grid-cols-3 md:grid-cols-5 border-foreground/10 border">
        <>
          <InfoLabel
            label="Quests"
            href={isFromCurrentUser && "/quests"}
            isLoading={!user || !questsData}
          >
            {user?.userQuests.length}/{questsData?.quests.length}
          </InfoLabel>
          <InfoLabel
            label="Ranking"
            href={
              isFromCurrentUser &&
              `/leaderboard?tab=my-tier&rank=${user?.gameProfile.rank}`
            }
            scroll={false}
            isLoading={!user}
          >
            #{user?.gameProfile.rank}
          </InfoLabel>
          <InfoLabel
            label="Points"
            href={
              isFromCurrentUser &&
              `/leaderboard?tab=my-tier&rank=${user?.gameProfile.rank}`
            }
            scroll={false}
            isLoading={!user}
          >
            {user?.gameProfile.score}
          </InfoLabel>
          <InfoLabel
            label="Multiplier"
            href={
              isFromCurrentUser &&
              `/leaderboard?tab=all-tiers&tier=${user?.gameProfile.tier.tierId}`
            }
            scroll={false}
            isLoading={!user}
          >
            {user?.gameProfile.tier.multiplier}x
          </InfoLabel>
          <InfoLabel
            label="Collection"
            href={isFromCurrentUser && "/achievements"}
            isLoading={!user}
          >
            {user?.userBadges.length} Badges
          </InfoLabel>
        </>
      </div>
      <div className="flex flex-col gap-0 absolute top-16 left-1/2 -translate-x-1/2 items-center">
        <div className="w-full px-5">
          <div className="max-w-fit mx-auto px-5 bg-background/80 pb-1 pt-3 flex flex-col gap-2 border-foreground/10 border rounded-t-2xl overflow-hidden items-center">
            <div className="size-20 border flex flex-col justify-center rounded-full">
              {userProfile?.avatarUrl && (
                <Image
                  width={200}
                  height={200}
                  src={userProfile?.avatarUrl}
                  alt="opSun"
                  className="size-full object-contain rounded-full"
                  unoptimized
                />
              )}
            </div>
            {userProfile?.name ? (
              <p className="font-bold text-sm text-foreground">
                {userProfile?.name}
              </p>
            ) : (
              <div className="h-4 my-1 animate-pulse bg-foreground/20 w-24 rounded-full" />
            )}
          </div>
        </div>
        <ConditionalWrapper
          condition={isFromCurrentUser}
          wrapper={(children) => (
            <Link
              href={`/leaderboard?tab=my-tier&rank=${user?.gameProfile.rank}`}
              className="hover:scale-105 transition duration-300"
            >
              {children}
            </Link>
          )}
        >
          <IndicatorPill className="px-8 min-w-48 h-[26px]">
            {user?.gameProfile.tier.displayData.title}
          </IndicatorPill>
        </ConditionalWrapper>
      </div>
    </div>
  );
};

interface InfoLabelProps extends ComponentProps<"p"> {
  label: string;
  href?: string;
  scroll?: boolean;
  isLoading?: boolean;
}

const InfoLabel = ({
  label,
  href,
  scroll = true,
  isLoading = false,
  ...props
}: InfoLabelProps) => {
  const infoLabelComponent = (
    <div className="flex flex-col gap-1 items-center">
      <p className="text-sm font-bold text-foreground/60">{label}</p>
      {isLoading ? (
        <div className="bg-foreground/20 animate-pulse w-10 h-4 my-1 rounded-full" />
      ) : (
        <p className="font-extrabold" {...props} />
      )}
    </div>
  );

  if (href) {
    return (
      <Link
        href={href}
        className="hover:scale-105 transition duration-300"
        scroll={scroll}
      >
        {infoLabelComponent}
      </Link>
    );
  }
  return infoLabelComponent;
};
