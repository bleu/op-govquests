"use server";

import { getQuests } from "@/utils/api";
import QuestsList from "./(components)/QuestsList";

export default async function Home() {
  const quests = await getQuests();

  return <QuestsList quests={quests} />;
}
