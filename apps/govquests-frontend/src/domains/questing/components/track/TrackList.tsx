import { useFetchTracks } from "../../hooks/useFetchTracks";
import { TrackAccordion } from "./TrackAccordion";

export const TrackList = () => {
  const { data } = useFetchTracks();

  return (
    data && (
      <div className="max-w-[1200px] mx-auto">
        <div className="flex flex-col border-b mb-7 pb-2 gap-2">
          <h1 className="text-2xl font-bold text-black/80"># Tracks</h1>
          <h2 className="text-xl font-normal text-black/80">
            Complete quests to earn points and unlock rewards.
          </h2>
        </div>
        <div className="px-8 flex flex-col gap-6">
          {data.tracks.map((track) => (
            <TrackAccordion track={track} key={track.id} />
          ))}
        </div>
      </div>
    )
  );
};
