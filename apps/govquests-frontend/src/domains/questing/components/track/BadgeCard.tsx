import { cn } from "@/lib/utils";
import { Badge } from "./TrackAccordion";
import Image from "next/image";
import Link from "next/link";

interface BadgeCardProps {
  badge: Badge;
  isCompleted: boolean;
}

export const BadgeCard = ({ badge, isCompleted }: BadgeCardProps) => {
  return (
    <div className="relative items-center justify-center min-w-52 h-60 col-span-2">
      <Link href={`/badges/${badge.id}`}>
        <Image
          src={badge.image}
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
  );
};
