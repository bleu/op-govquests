import { IndicatorPill } from "@/components/IndicatorPill";
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
        <IndicatorPill>{track.quests.length} quests</IndicatorPill>
        <IndicatorPill>{track.totalPoints} points</IndicatorPill>
      </div>
    </div>
  );
};
