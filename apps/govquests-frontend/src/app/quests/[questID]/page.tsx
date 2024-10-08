"use client";

import QuestDetails from "@/domains/questing/components/QuestDetails";
import { useFetchQuest } from "@/domains/questing/hooks/useFetchQuest";

import LoadingIndicator from "@/components/ui/LoadingIndicator";

interface QuestDetailsPageProps {
  params: {
    questID: string;
  };
}

export default function QuestDetailsPage({
  params: { questID },
}: QuestDetailsPageProps) {
  const { data, isLoading, isError } = useFetchQuest(questID as string);

  if (isLoading) return <LoadingIndicator />;
  if (isError || !data?.quest) return <p>Error loading quest details.</p>;

  return <QuestDetails quest={data.quest} />;
}
