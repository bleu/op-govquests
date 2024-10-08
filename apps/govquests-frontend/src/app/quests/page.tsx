"use client";

import { useFetchQuests } from "@/domains/questing/hooks/useFetchQuests";
import QuestList from "@/domains/questing/components/QuestList";
import LoadingIndicator from "@/components/ui/LoadingIndicator";

export default function QuestsPage() {
  const { data, isLoading, isError } = useFetchQuests();

  if (isLoading) return <LoadingIndicator />;
  if (isError || !data) return <p>Error loading quests.</p>;

  return <QuestList quests={data.quests} />;
}
