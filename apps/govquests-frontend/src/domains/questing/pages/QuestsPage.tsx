import React from "react";
import { useFetchQuests } from "../hooks/useFetchQuests";
import QuestList from "../components/QuestList";
import LoadingIndicator from "@/components/ui/LoadingIndicator";

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
