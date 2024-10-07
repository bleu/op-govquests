"use server";

import api from "@/lib/api";
import { Suspense } from "react";
import QuestsList from "./(components)/QuestsList";
import Loading from "./loading";

export default async function Quests() {
  const quests = await api("quests");

  return (
    <Suspense fallback={<Loading />}>
      <QuestsList quests={quests} />
    </Suspense>
  );
}
