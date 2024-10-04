"use server";

import api from "@/lib/api";
import QuestsList from "./(components)/QuestsList";

export default async function Quests() {
  const quests = await api("quests");

  return <QuestsList quests={quests} />;
}
