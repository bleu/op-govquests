"use client";

import { cn, koulen, redactedScript } from "@/lib/utils";
import Image from "next/image";
import { ComponentProps } from "react";
import { useFetchBadge } from "../hooks/useFetchBadge";

interface BadgeCardProps {
  badgeId: string;
  isCompleted: boolean;
  className?: string;
  withTitle?: boolean;
  header?: string;
}

export const BadgeCard = ({
  badgeId,
  isCompleted,
  className,
  withTitle = false,
  header,
}: BadgeCardProps) => {
  const { data } = useFetchBadge(badgeId);

  const Card = data && (
    <div
      className={cn(
        "relative items-center justify-center col-span-2",
        className,
      )}
    >
      <Image
        src={data.badge.displayData.imageUrl}
        alt="badge_image"
        width={100}
        height={100}
        className={cn(
          "object-cover w-full h-full grayscale",
          isCompleted && "grayscale-0",
        )}
        unoptimized
      />
      <div
        className={cn(
          "absolute w-full right-0 flex h-full top-0 pb-[19.5%] items-end whitespace-nowrap",
          isCompleted ? koulen.className : redactedScript.className,
        )}
      >
        <span
          className={cn(
            "text-primary-foreground w-full text-center translate-y-1/2 tracking-tighter text-lg",
            !isCompleted && "scale-x-75",
          )}
        >
          {data.badge.displayData.title}
        </span>
      </div>
    </div>
  );

  if (withTitle)
    return (
      <BadgeCardTitle
        header={header}
        badgeableTitle={data?.badge.badgeable.displayData.title}
      >
        {Card}
      </BadgeCardTitle>
    );
  else return Card;
};

interface BadgeCardTitleProps extends ComponentProps<"div"> {
  header: string;
  badgeableTitle: string;
}

const BadgeCardTitle = ({
  header,
  badgeableTitle,
  children,
}: BadgeCardTitleProps) => {
  return (
    <div className="my-5 p-2 rounded-lg bg-background/60 transition duration-300 hover:scale-105 flex flex-col">
      <div className="px-2 whitespace-nowrap w-full text-start">
        <h2 className="text-sm font-bold">{header.toUpperCase()}</h2>
        <span className="text-xs font-thin">
          {badgeableTitle?.toUpperCase() || ""}
        </span>
      </div>
      <div className="w-full">{children}</div>
    </div>
  );
};
