"use client";

import { useBreakpoints } from "@/hooks/useBreakpoints";
import type { Tracks } from "../../types/trackTypes";
import { TrackIndicatorPills } from "./TrackIndicatorPills";

interface TrackAccordionHeader {
  track: Tracks[number];
}

export const TrackAccordionHeader = ({ track }: TrackAccordionHeader) => {
  const { isLargerThan } = useBreakpoints();

  return (
    <div className="flex justify-between items-center w-full pr-10">
      <h1 className="md:text-2xl font-bold flex gap-2 text-xl">
        <p className="text-foreground/60"># {isLargerThan.md && "TRACK"}</p>{" "}
        {track.displayData.title}
      </h1>
      {isLargerThan.md && <TrackIndicatorPills track={track} />}
    </div>
  );
};
