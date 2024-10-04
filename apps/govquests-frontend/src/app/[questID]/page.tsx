"use server";

import api from "@/utils/api";
import QuestDetails from "../(components)/QuestDetails";

interface Params {
  questID: string;
}

export default async function QuestDetailsPage({ params }: { params: Params }) {
  const quest = await api(`quests/${params.questID}`);

  return <QuestDetails quest={quest} />;
}
