import LoadingIndicator from "@/components/ui/LoadingIndicator";
import React from "react";
import QuestList from "../components/QuestList";
import { useFetchQuests } from "../hooks/useFetchQuests";

const QuestsPage: React.FC = () => {
  const { data, isLoading, isError } = useFetchQuests();
  if (isLoading) {
    return <LoadingIndicator />;
  }

  if (isError || !data) {
    return <p>Error loading quests.</p>;
  }

  return (
    <div className="p-8">
      <QuestList quests={data.quests} />
    </div>
  );
};

export default QuestsPage;
