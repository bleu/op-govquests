import { Badge } from "./TrackAccordion";
import Image from "next/image";

export const BadgeCard = ({ badge }: { badge: Badge }) => {
  return (
    <div className="items-center justify-center min-w-52 h-60 border col-span-2">
      <Image
        src={badge.image}
        alt="badge_image"
        width={100}
        height={100}
        className="object-cover w-full h-full"
        unoptimized
      />
    </div>
  );
};
