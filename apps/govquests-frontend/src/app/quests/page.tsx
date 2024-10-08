"use server";

import { Suspense } from "react";
import QuestsList from "./(components)/quests-list";
import Loading from "./loading";
import { QuestsQuery } from "./(components)/quests-query";
import request from "graphql-request";

export default async function Quests() {
  const data = await request("http://localhost:3001/graphql", QuestsQuery);

  return (
    <Suspense fallback={<Loading />}>
      <QuestsList quests={data.quests} />
    </Suspense>
  );
}
