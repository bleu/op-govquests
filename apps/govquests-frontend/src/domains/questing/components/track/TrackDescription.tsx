import Link from "next/link";
import { BadgeCard } from "../../../gamification/components/BadgeCard";
import { Tracks } from "../../types/trackTypes";

interface TrackDescriptionProps {
  track: Tracks[number];
}

export const TrackDescription = ({ track }: TrackDescriptionProps) => {
  return (
    <div className="flex flex-col gap-8 mt-7">
      <div className="flex items-center justify-center w-full gap-9">
        <div className="border-b h-0 w-full" />
        <div className="text-xl font-bold whitespace-nowrap">
          About this track
        </div>
        <div className="border-b h-0 w-full" />
      </div>
      <div className="items-center justify-center flex gap-12 mx-20">
        {track.badge.displayData.imageUrl && (
          <Link href={`/badges/${track.badge.id}`}>
            <BadgeCard
              badgeId={track.badge.id}
              isCompleted={track.isCompleted}
              className="hover:scale-105 transition-all duration-300"
            />
          </Link>
        )}
        <div className="flex flex-col gap-4 col-span-8 w-full font-bold">
          <span>{track.displayData.description}</span>
          <span>
            {track.isCompleted
              ? `Track completed — ${track.badge.displayData.title} unlocked. `
              : "Complete all quests to Unlock this Track Badge."}
          </span>
        </div>
      </div>
    </div>
  );
};
