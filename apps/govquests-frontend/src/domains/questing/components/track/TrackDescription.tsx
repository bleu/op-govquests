"use client";

import { BadgeDialog } from "@/domains/gamification/components/BadgeDialog";
import { NormalBadgeCard } from "../../../gamification/components/BadgeCard";
import type { Tracks } from "../../types/trackTypes";
import { TrackIndicatorPills } from "./TrackIndicatorPills";

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
      <div className="items-center justify-center flex md:gap-12 gap-4 md:mx-20 mx-4 flex-col md:flex-row">
        <BadgeDialog badgeId={track.badge.id}>
          <div className="w-52">
            <NormalBadgeCard
              badgeId={track.badge.id}
              className="hover:scale-105 transition-all duration-300 w-full h-60"
            />
          </div>
        </BadgeDialog>
        <TrackIndicatorPills
          track={track}
          className="flex gap-2 w-full px-2 items-center justify-center"
        />
        <div className="flex flex-col gap-4 col-span-8 w-full font-bold text-center md:text-left">
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
