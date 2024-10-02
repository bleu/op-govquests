import Quest from "@/components/Quest";
import type { Reward } from "@/types/quest";
import type React from "react";

interface QuestProps {
  id: string;
  title: string;
  img_url: string;
  rewards: Reward[];
  status: string;
}

interface QuestsListProps {
  quests: QuestProps[];
}

const QuestsList: React.FC<QuestsListProps> = ({ quests }) => {
  return (
    <main className="p-6 flex-1">
      <h2 className="text-2xl">Here's some quests for you!</h2>
      <span className="text-lg bg-green mb-4">
        We selected them based on your profile
      </span>
      <div className="mt-6 grid grid-cols-2 md:grid-cols-3 lg:grid-cols-4 2xl:grid-cols-5 gap-5">
        {quests.map((quest) => (
          <Quest
            key={quest.id}
            id={quest.id}
            title={quest.title}
            altText={quest.title}
            imageSrc={quest.img_url}
            rewards={quest.rewards}
            status={quest.status}
          />
        ))}
      </div>
    </main>
  );
};

export default QuestsList;
