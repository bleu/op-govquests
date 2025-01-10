import { IndicatorPill } from "@/components/IndicatorPill";
import { Tracks } from "../../types/trackTypes";

interface TrackAccordionHeader {
  track: Tracks[number];
  isCompleted: boolean;
}

export const TrackAccordionHeader = ({
  track,
  isCompleted,
}: TrackAccordionHeader) => {
  return (
    <div className="flex justify-between items-center w-full pr-10">
      <h1 className="text-2xl font-bold flex gap-2">
        <p className="text-foreground/60">#TRACK</p> {track.displayData.title}
      </h1>
      <div className="flex gap-4 hover:no-underline">
        <IndicatorPill>{track.quests.length} quests</IndicatorPill>
        <IndicatorPill>
          {isCompleted ? "Completed" : track.points + " points"}
        </IndicatorPill>
      </div>
    </div>
  );
};
