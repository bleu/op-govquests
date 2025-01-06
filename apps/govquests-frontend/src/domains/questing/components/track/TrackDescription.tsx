import { BadgeCard } from "./BadgeCard";
import { Track } from "./TrackAccordion";

export const TrackDescription = ({ track }: { track: Track }) => {
  const isCompleted = track.quests
    .map((quest) => quest.userQuests[0]?.status)
    .every((status) => status === "completed");

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
        <BadgeCard badge={track.badge} isCompleted={isCompleted} />
        <div className="flex flex-col gap-4 col-span-8 w-full font-bold">
          <span>{track.description}</span>
          <span>
            {isCompleted
              ? `Track completed — ${track.badge.name} unlocked. `
              : "Complete all quests to Unlock this Track Badge."}
          </span>
        </div>
      </div>
    </div>
  );
};
