import { Track } from "./TrackAccordion";

interface TrackAccordionHeader {
  track: Track;
}

export const TrackAccordionHeader = ({ track }: TrackAccordionHeader) => {
  return (
    <div className="flex justify-between items-center w-full pr-10">
      <h1 className="text-2xl font-bold flex gap-2">
        <p className="text-foreground/60">#TRACK</p> {track.title}
      </h1>
      <div className="flex gap-4 hover:no-underline">
        <div className="flex border py-1 px-4 rounded-lg hover:no-underline">
          <p className="text-sm font-bold hover:no-underline">
            {track.quests.length} quests
          </p>
        </div>
        <div className="flex border py-1 px-4 rounded-lg">
          <p className="text-sm font-bold">{track.totalPoints} points</p>
        </div>
      </div>
    </div>
  );
};
