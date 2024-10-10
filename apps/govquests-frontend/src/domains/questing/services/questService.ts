import request from "graphql-request";
import { QuestQuery } from "../graphql/questQuery";
import { QuestsQuery } from "../graphql/questsQuery";

const API_URL =
  process.env.NEXT_PUBLIC_API_URL || "http://localhost:3000/graphql";

export const fetchAllQuests = async () => {
  return await request(API_URL, QuestsQuery);
};

export const fetchQuestById = async (id: string) => {
  return await request(API_URL, QuestQuery, { id });
};
