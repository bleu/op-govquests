import { IndicatorPill } from "@/components/IndicatorPill";
import type { Tracks } from "../../types/trackTypes";
import { cn } from "@/lib/utils";
import type { ComponentProps } from "react";

interface TrackIndicatorPillsProps extends ComponentProps<"div"> {
  track: Tracks[number];
}

export const TrackIndicatorPills = ({
  track,
  className,
  ...props
}: TrackIndicatorPillsProps) => {
  return (
    <div className={cn("grid grid-cols-2 gap-4 w-64", className)} {...props}>
      <IndicatorPill className="w-fit justify-self-end">
        {track.quests.length} quests
      </IndicatorPill>
      <IndicatorPill className="w-fit justify-self-end">
        {track.isCompleted ? "Completed" : `${track.points} points`}
      </IndicatorPill>
    </div>
  );
};
