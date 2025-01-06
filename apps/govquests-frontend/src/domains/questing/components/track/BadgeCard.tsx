import { cn } from "@/lib/utils";
import { Badge } from "./TrackAccordion";
import Image from "next/image";

interface BadgeCardProps {
  badge: Badge;
  isCompleted: boolean;
}

export const BadgeCard = ({ badge, isCompleted }: BadgeCardProps) => {
  // TODO - Add badge image

  return (
    <div className="relative items-center justify-center min-w-52 h-60 col-span-2">
      <Image
        src={"/badges/track1.png"}
        alt="badge_image"
        width={100}
        height={100}
        className={cn(
          "object-cover w-full h-full grayscale",
          isCompleted && "grayscale-0",
        )}
        unoptimized
      />
    </div>
  );
};
