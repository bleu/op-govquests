import request from "graphql-request";
import { QuestQuery } from "../graphql/questQuery";
import { QuestsQuery } from "../graphql/questsQuery";
import { API_URL } from "@/lib/utils";

export const fetchAllQuests = async () => {
  return await request(API_URL, QuestsQuery);
};

export const fetchQuestById = async (id: string) => {
  return await request(API_URL, QuestQuery, { id });
};
