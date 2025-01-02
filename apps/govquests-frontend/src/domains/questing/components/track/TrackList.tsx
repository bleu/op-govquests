import { useFetchQuests } from "../../hooks/useFetchQuests";
import { Track, TrackAccordion } from "./TrackAccordion";

const mockTracks: Track[] = [
  {
    id: 1,
    title: "Track 1",
    description: "Description 1",
    image: "https://via.placeholder.com/150",
    totalPoints: 0,
    badge: {
      id: 0,
      name: "Teste",
      image: "https://placehold.co/400",
    },
    quests: [],
  },
];

export const TrackList = () => {
  const { data } = useFetchQuests();

  return (
    <div>
      <div className="flex flex-col gap-3 border-b mb-7 pb-3">
        <h1 className="text-2xl font-bold text-black/80"># Tracks</h1>
        <h2 className="text-xl font-normal text-black/80">
          Complete quests to earn points and unlock rewards.
        </h2>
      </div>
      {mockTracks.map((track) => (
        <TrackAccordion
          track={{ ...track, quests: data.quests }}
          key={track.id}
        />
      ))}
    </div>
  );
};
