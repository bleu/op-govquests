"use server";

import api from "@/lib/api";
import QuestDetails from "./(components)/quest-details";
import request from "graphql-request";
import { QuestQuery } from "./(components)/quest-query";

interface Params {
  questID: string;
}

export default async function QuestDetailsPage({ params }: { params: Params }) {
  const data = await request("http://localhost:3001/graphql", QuestQuery, {
    id: params.questID,
  });

  return <QuestDetails quest={data.quest} />;
}
