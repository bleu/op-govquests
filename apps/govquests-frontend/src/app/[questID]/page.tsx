"use server";

import { getQuestById } from "@/utils/api";
import type React from "react";
import QuestDetails from "../(components)/QuestDetails";

interface QuestDetailsProps {
  questID: string;
}

const QuestDetailsPage: React.FC<QuestDetailsProps> = async ({ questID }) => {
  const quest = await getQuestById(questID);

  return <QuestDetails quest={quest} />;
};

export default QuestDetailsPage;
