import { Tracks } from "../../types/trackTypes";

interface TrackAccordionHeader {
  track: Tracks[number];
}

export const TrackAccordionHeader = ({ track }: TrackAccordionHeader) => {
  return (
    <div className="flex justify-between items-center w-full pr-10">
      <h1 className="text-2xl font-bold text-black/80 flex gap-2">
        <p className="text-black/60">#TRACK</p> {track.displayData.title}
      </h1>
      <div className="flex gap-4 hover:no-underline">
        <div className="flex border py-1 px-4 rounded-lg hover:no-underline">
          <p className="text-sm font-bold hover:no-underline">
            {track.quests.length} quests
          </p>
        </div>
        <div className="flex border py-1 px-4 rounded-lg">
          <p className="text-sm font-bold">{track.points} points</p>
        </div>
      </div>
    </div>
  );
};
