"use server";

import api from "@/utils/api";
import QuestsList from "./(components)/QuestsList";

export default async function Home() {
  const quests = await api("quests");

  return <QuestsList quests={quests} />;
}
