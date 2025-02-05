import { IndicatorPill } from "@/components/IndicatorPill";
import { Tracks } from "../../types/trackTypes";

interface TrackAccordionHeader {
  track: Tracks[number];
}

export const TrackAccordionHeader = ({ track }: TrackAccordionHeader) => {
  return (
    <div className="flex justify-between items-center w-full pr-10">
      <h1 className="text-2xl font-bold flex gap-2">
        <p className="text-foreground/60">#TRACK</p> {track.displayData.title}
      </h1>
      <div className="grid grid-cols-2 gap-4 w-64">
        <IndicatorPill className="w-fit justify-self-end">
          {track.quests.length} quests
        </IndicatorPill>
        <IndicatorPill className="w-fit justify-self-end">
          {track.isCompleted ? "Completed" : track.points + " points"}
        </IndicatorPill>
      </div>
    </div>
  );
};
