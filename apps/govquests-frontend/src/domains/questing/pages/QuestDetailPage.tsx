import React from "react";
import { useRouter } from "next/router";
import { useFetchQuest } from "../hooks/useFetchQuest";
import QuestDetails from "../components/QuestDetails";
import LoadingIndicator from "@/components/ui/LoadingIndicator";

const QuestDetailsPage: React.FC = () => {
  const router = useRouter();
  const { questID } = router.query;
  const { data, isLoading, isError } = useFetchQuest(questID as string);

  if (isLoading) {
    return <LoadingIndicator />;
  }

  if (isError || !data || !data.quest) {
    return <p>Error loading quest details.</p>;
  }

  return <QuestDetails quest={data.quest} />;
};

export default QuestDetailsPage;
