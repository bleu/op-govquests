import React from "react";
import { Quests } from "../types/questTypes";
import QuestCard from "./QuestCard";
import { MapIcon } from "lucide-react";

interface QuestListProps {
  quests: Quests;
}

const QuestList: React.FC<QuestListProps> = ({ quests }) => {
  return (
    <main className="p-12 flex-1">
      <div className="flex items-center">
        <MapIcon width={30} height={30} />
        <h2 className="text-3xl ml-3 font-medium">Our suggestions for you</h2>
      </div>
      <div className="mt-6 grid grid-cols-2 md:grid-cols-3 lg:grid-cols-4 2xl:grid-cols-5 gap-7">
        {quests.map((quest) => (
          <QuestCard key={quest.id} quest={quest} />
        ))}
      </div>
    </main>
  );
};

export default QuestList;
