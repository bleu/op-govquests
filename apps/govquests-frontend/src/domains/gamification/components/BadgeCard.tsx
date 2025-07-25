"use client";

import { cn, koulen, redactedScript } from "@/lib/utils";
import Image from "next/image";
import { type ComponentProps, useState } from "react";
import { useFetchBadge } from "../hooks/useFetchBadge";
import { useFetchSpecialBadge } from "../hooks/useFetchSpecialBadge";
import { IndicatorPill } from "@/components/IndicatorPill";

interface BadgeCardProps {
  badgeId: string;
  badge:
    | ReturnType<typeof useFetchBadge>["data"]["badge"]
    | ReturnType<typeof useFetchSpecialBadge>["data"]["specialBadge"];
  className?: string;
  scaleDisabled?: boolean;
  withTitle?: boolean;
  header?: string;
  revealIncomplete?: boolean;
  badgeableTitle?: string;
  hasOpReward?: boolean;
}

export const NormalBadgeCard = (
  props: Omit<BadgeCardProps, "badge" | "badgeableTitle">,
) => {
  const { data } = useFetchBadge(props.badgeId);

  return (
    <BadgeCard
      badge={data?.badge}
      badgeableTitle={data?.badge.badgeable.displayData.title}
      {...props}
    />
  );
};

export const SpecialBadgeCard = (
  props: Omit<BadgeCardProps, "badge" | "badgeableTitle">,
) => {
  const { data } = useFetchSpecialBadge(props.badgeId);

  const hasOpReward = data?.specialBadge?.rewardPools.some(
    (pool) => pool.rewardDefinition.type === "Token",
  );

  return (
    <BadgeCard
      badge={data?.specialBadge}
      {...props}
      hasOpReward={hasOpReward}
    />
  );
};

export const BadgeCard = ({
  className,
  revealIncomplete = false,
  badge,
  withTitle,
  badgeableTitle,
  header,
  scaleDisabled = false,
  hasOpReward,
}: BadgeCardProps) => {
  const revealCard = badge?.earnedByCurrentUser || revealIncomplete;

  const [imageLoaded, setImageLoaded] = useState(false);

  const Card = (
    <div
      className={cn(
        "relative items-center justify-center col-span-2",
        className,
      )}
    >
      <div className="relative w-full h-full aspect-[9/10]">
        <Image
          src={badge?.displayData.imageUrl}
          alt="badge_image"
          width={100}
          height={100}
          className={cn(
            "object-cover w-full h-full grayscale opacity-0 transition-opacity duration-300",
            imageLoaded && "opacity-100",
            revealCard && "grayscale-0",
          )}
          unoptimized
          onLoadingComplete={() => setImageLoaded(true)}
        />
        <div
          className={cn(
            "absolute w-full right-0 flex h-full top-0 pb-[19.5%] items-end whitespace-nowrap",
            revealCard ? koulen.className : redactedScript.className,
          )}
        >
          {imageLoaded && (
            <span
              className={cn(
                "text-primary-foreground w-4/5 mx-auto text-center translate-y-1/2 tracking-tighter text-lg truncate",
                !revealCard && "scale-x-75",
              )}
            >
              {badge?.displayData.title}
            </span>
          )}
        </div>
        {hasOpReward && !revealCard && (
          <IndicatorPill className="absolute top-2 right-2 !bg-gradient-to-r !from-[#7D72F5DD] !to-[#B84577DD] text-xs font-thin h-5 px-3 w-fit">
            OP Rewards!
          </IndicatorPill>
        )}
      </div>
    </div>
  );

  if (!badge) return <CardSkeleton withTitle={withTitle} />;

  if (withTitle) {
    return (
      <BadgeCardTitle
        header={header}
        badgeableTitle={badgeableTitle}
        scaleDisabled={scaleDisabled}
      >
        {Card}
      </BadgeCardTitle>
    );
  }
  return Card;
};

interface BadgeCardTitleProps extends ComponentProps<"div"> {
  header: string;
  badgeableTitle?: string;
  scaleDisabled?: boolean;
}

const BadgeCardTitle = ({
  header,
  badgeableTitle,
  children,
  scaleDisabled,
  ...props
}: BadgeCardTitleProps) => {
  return (
    <div
      className={cn(
        "p-2 rounded-lg bg-background/60 flex flex-col",
        !scaleDisabled && "transition duration-300 hover:scale-105",
      )}
      {...props}
    >
      <div className="px-2 whitespace-nowrap w-full text-start">
        <h2 className="text-sm font-bold">{header.toUpperCase()}</h2>
        {badgeableTitle && (
          <div className="text-xs font-thin truncate my-1">
            {badgeableTitle?.toUpperCase() || ""}
          </div>
        )}
      </div>
      <div className="w-full">{children}</div>
    </div>
  );
};

const CardSkeleton = ({ withTitle }: { withTitle: boolean }) => {
  return (
    <div
      className={cn(
        "rounded-lg bg-background/60 transition w-full my-1",
        withTitle && "p-2",
      )}
    >
      {withTitle && (
        <>
          <div className="mx-2 w-2/3 h-3 animate-pulse bg-foreground/5 rounded-md" />
          <div className="mx-2 h-3 animate-pulse bg-foreground/5 rounded-md mt-2 mb-2" />
        </>
      )}
      <div
        className={cn(
          "aspect-[9/10] animate-pulse bg-foreground/5 rounded-md",
          withTitle && "m-2",
        )}
      />
    </div>
  );
};
