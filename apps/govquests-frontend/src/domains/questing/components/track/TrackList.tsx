import { SectionHeader } from "@/components/SectionHeader";
import { useFetchTracks } from "../../hooks/useFetchTracks";
import { TrackAccordion } from "./TrackAccordion";

export const TrackList = () => {
  const { data } = useFetchTracks();

  return (
    data && (
      <div className="max-w-[1200px] mx-auto px-6 space-y-6">
        <SectionHeader
          title="Tracks"
          description="Complete quests to earn points and unlock rewards."
        />
        <div className="flex flex-col gap-6">
          {data.tracks.map((track) => (
            <TrackAccordion track={track} key={track.id} />
          ))}
        </div>
      </div>
    )
  );
};
