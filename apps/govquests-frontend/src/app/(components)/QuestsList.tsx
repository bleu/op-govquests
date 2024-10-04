import Quest from "@/components/Quest";
import type { Quest as IQuest, Reward } from "@/types/quest";
import { MapIcon } from "lucide-react";
import type React from "react";

interface QuestsListProps {
  quests: Pick<
    IQuest,
    "id" | "title" | "intro" | "image_url" | "rewards" | "status"
  >[];
}

const QuestsList: React.FC<QuestsListProps> = ({ quests }) => {
  return (
    <main className="p-12 flex-1">
      <div className="flex items-center">
        <MapIcon width={30} height={30} />
        <h2 className="text-3xl ml-3 font-medium">Our suggestions for you</h2>
      </div>
      <div className="mt-6 grid grid-cols-2 md:grid-cols-3 lg:grid-cols-4 2xl:grid-cols-5 gap-7">
        {quests.map((quest) => (
          <Quest
            key={quest.id}
            id={quest.id}
            title={quest.title}
            intro={quest.intro}
            imageSrc={quest.image_url}
            rewards={quest.rewards}
          />
        ))}
      </div>
    </main>
  );
};

export default QuestsList;
