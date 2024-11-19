import { Quests } from "../types/questTypes";
import QuestCard from "./QuestCard";

interface QuestTrackProps {
  quest: Quests[number];
}

const QuestTrack = ({ quest }: QuestTrackProps) => {
  return (
    <div className="border-t py-7">
      <QuestCard quest={quest} />
    </div>
  );
};

export default QuestTrack;
