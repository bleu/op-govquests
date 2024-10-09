"use client";

import LoadingIndicator from "@/components/ui/LoadingIndicator";
import QuestList from "@/domains/questing/components/QuestList";
import { useFetchQuests } from "@/domains/questing/hooks/useFetchQuests";

export default function QuestsPage() {
  const { data, isLoading, isError } = useFetchQuests();
  console.log(data);

  if (isLoading) return <LoadingIndicator />;
  if (isError || !data) return <p>Error loading quests.</p>;

  return <QuestList quests={data.quests} />;
}
