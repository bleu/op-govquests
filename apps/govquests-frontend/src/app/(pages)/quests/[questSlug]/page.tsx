"use client";

import { use } from "react";

import LoadingIndicator from "@/components/ui/LoadingIndicator";
import { useFetchQuest } from "@/domains/questing/hooks/useFetchQuest";
import QuestDetails from "@/domains/questing/components/QuestDetails";

interface QuestDetailsPageProps {
  params: Promise<{
    questSlug: string;
  }>;
}

export default function QuestDetailsPage(props: QuestDetailsPageProps) {
  const params = use(props.params);

  const { questSlug } = params;

  const { data, isLoading, isError } = useFetchQuest(questSlug as string);

  if (isLoading) {
    return <LoadingIndicator />;
  }

  if (isError || !data || !data.quest) {
    return <p>Error loading quest details.</p>;
  }

  return <QuestDetails quest={data.quest} />;
}
