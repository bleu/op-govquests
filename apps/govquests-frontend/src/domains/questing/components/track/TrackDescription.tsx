import { BadgeCard } from "../../../gamification/components/BadgeCard";
import { Tracks } from "../../types/trackTypes";

interface TrackDescriptionProps {
  track: Tracks[number];
  isCompleted: boolean;
}

export const TrackDescription = ({
  track,
  isCompleted,
}: TrackDescriptionProps) => {
  const badge = { id: "1", image: "/badge/track1.png", title: "Track Badge" };

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
        <BadgeCard badgeId={track.badge.id} isCompleted={isCompleted} />
        <div className="flex flex-col gap-4 col-span-8 w-full font-bold">
          <span>{track.displayData.description}</span>
          <span>
            {isCompleted
              ? `Track completed — ${badge.title} unlocked. `
              : "Complete all quests to Unlock this Track Badge."}
          </span>
        </div>
      </div>
    </div>
  );
};
