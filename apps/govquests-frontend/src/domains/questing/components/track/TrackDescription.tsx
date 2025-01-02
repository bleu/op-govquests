import { BadgeCard } from "./BadgeCard";
import { Track } from "./TrackAccordion";

export const TrackDescription = ({ track }: { track: Track }) => {
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
        <BadgeCard badge={track.badge} />
        <div className="col-span-8 w-full">
          {track.description} Lorem ipsum dolor sit amet consectetur adipisicing
          elit. Impedit incidunt architecto soluta ab magnam explicabo
          voluptatem nulla sit nihil eaque! Magni tempora explicabo eum
          laboriosam, at asperiores. Rem, incidunt nemo!
        </div>
      </div>
    </div>
  );
};
