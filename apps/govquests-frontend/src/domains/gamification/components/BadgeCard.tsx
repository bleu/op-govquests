import { cn, koulen, redactedScript } from "@/lib/utils";
import Image from "next/image";
import Link from "next/link";
import { useFetchBadge } from "../hooks/useFetchBadge";

interface BadgeCardProps {
  badgeId: string;
  isCompleted: boolean;
}

export const BadgeCard = ({ badgeId, isCompleted }: BadgeCardProps) => {
  const { data } = useFetchBadge(badgeId);

  return (
    data && (
      <div className="relative items-center justify-center min-w-52 h-60 col-span-2 group">
        {data.badge.displayData.imageUrl && (
          <Link href={`/badges/${data.badge.id}`}>
            <Image
              src={data.badge.displayData.imageUrl}
              alt="badge_image"
              width={100}
              height={100}
              className={cn(
                "object-cover w-full h-full grayscale group-hover:scale-105 transition-all duration-300",
                isCompleted && "grayscale-0",
              )}
              unoptimized
            />
            <div
              className={cn(
                "absolute left-1/2 -translate-x-1/2 group-hover:scale-105 flex h-full top-0 pb-[42px] items-end transition-all duration-300",
                isCompleted ? koulen.className : redactedScript.className,
              )}
            >
              <span className="text-primary-foreground translate-y-1/2 font-medium text-lg whitespace-nowrap">
                {data.badge.displayData.title}
              </span>
            </div>
          </Link>
        )}
      </div>
    )
  );
};
