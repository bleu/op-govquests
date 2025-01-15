"use client";

import { cn, koulen, redactedScript } from "@/lib/utils";
import Image from "next/image";
import { useFetchBadge } from "../hooks/useFetchBadge";

interface BadgeCardProps {
  badgeId: string;
  isCompleted: boolean;
  className?: string;
}

export const BadgeCard = ({
  badgeId,
  isCompleted,
  className,
}: BadgeCardProps) => {
  const { data } = useFetchBadge(badgeId);

  return (
    data && (
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
    )
  );
};
