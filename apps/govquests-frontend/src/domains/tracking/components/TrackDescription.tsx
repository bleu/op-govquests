import { BadgeCard } from "./BadgeCard";
import { Tracks } from "../types/trackTypes";

export const TrackDescription = ({ track }: { track: Tracks[number] }) => {
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
        <BadgeCard />
        <div className="col-span-8 w-full">{track.displayData.description}</div>
      </div>
    </div>
  );
};
