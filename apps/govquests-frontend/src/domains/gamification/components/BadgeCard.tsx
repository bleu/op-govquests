"use client";

import { cn, koulen, redactedScript } from "@/lib/utils";
import Image from "next/image";
import { ComponentProps, useState } from "react";
import { useFetchBadge } from "../hooks/useFetchBadge";
import { useFetchSpecialBadge } from "../hooks/useFetchSpecialBadge";

interface BadgeCardProps {
  badgeId: string;
  badge:
    | ReturnType<typeof useFetchBadge>["data"]["badge"]
    | ReturnType<typeof useFetchSpecialBadge>["data"]["specialBadge"];
  className?: string;
  withTitle?: boolean;
  header?: string;
  revealIncomplete?: boolean;
}

export const NormalBadgeCard = (props: Omit<BadgeCardProps, "badge">) => {
  const { data } = useFetchBadge(props.badgeId);

  if (props.withTitle)
    return (
      data && (
        <BadgeCardTitle
          header={props.header}
          badgeableTitle={data?.badge.badgeable.displayData.title}
        >
          <BadgeCard badge={data.badge} {...props} />
        </BadgeCardTitle>
      )
    );
  else return data && <BadgeCard badge={data.badge} {...props} />;
};

export const SpecialBadgeCard = (props: Omit<BadgeCardProps, "badge">) => {
  const { data } = useFetchSpecialBadge(props.badgeId);

  if (props.withTitle)
    return (
      data && (
        <BadgeCardTitle header={props.header}>
          <BadgeCard badge={data.specialBadge} {...props} />
        </BadgeCardTitle>
      )
    );
  else return data && <BadgeCard badge={data.specialBadge} {...props} />;
};

export const BadgeCard = ({
  className,
  revealIncomplete = false,
  badge,
}: BadgeCardProps) => {
  const revealCard = badge.earnedByCurrentUser || revealIncomplete;

  const [imageLoaded, setImageLoaded] = useState(false);

  return (
    <div
      className={cn(
        "relative items-center justify-center col-span-2",
        className,
      )}
    >
      <div className="relative w-full h-full aspect-[9/10]">
        <Image
          src={badge.displayData.imageUrl}
          alt="badge_image"
          width={100}
          height={100}
          className={cn(
            "object-cover w-full h-full grayscale",
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
                "text-primary-foreground w-full text-center translate-y-1/2 tracking-tighter text-lg",
                !revealCard && "scale-x-75",
              )}
            >
              {badge.displayData.title}
            </span>
          )}
        </div>
      </div>
    </div>
  );
};

interface BadgeCardTitleProps extends ComponentProps<"div"> {
  header: string;
  badgeableTitle?: string;
}

const BadgeCardTitle = ({
  header,
  badgeableTitle,
  children,
}: BadgeCardTitleProps) => {
  return (
    <div className="p-2 rounded-lg bg-background/60 transition duration-300 hover:scale-105 flex flex-col">
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
