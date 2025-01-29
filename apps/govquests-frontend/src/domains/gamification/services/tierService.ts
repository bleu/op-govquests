import { API_URL } from "@/lib/utils";
import request from "graphql-request";
import { TIER_QUERY, TIERS_QUERY } from "../graphql/tierQuery";

export const fetchTier = async (id: string) => {
  return await request(API_URL, TIER_QUERY, { id });
};

export const fetchTiers = async () => {
  return await request(API_URL, TIERS_QUERY);
};
