import { cn } from "@/lib/utils";
import Image from "next/image";
import Link from "next/link";
import { useFetchBadge } from "../../questing/hooks/useFetchBadge";

interface BadgeCardProps {
  badgeId: string;
  isCompleted: boolean;
}

export const BadgeCard = ({ badgeId, isCompleted }: BadgeCardProps) => {
  const { data } = useFetchBadge(badgeId);

  return (
    data && (
      <div className="relative items-center justify-center min-w-52 h-60 col-span-2">
        <Link href={`/badges/${data.badge.id}`}>
          <Image
            src={data.badge.displayData.imageUrl || ""}
            alt="badge_image"
            width={100}
            height={100}
            className={cn(
              "object-cover w-full h-full grayscale hover:scale-105 transition-all duration-300",
              isCompleted && "grayscale-0",
            )}
            unoptimized
          />
        </Link>
      </div>
    )
  );
};
