import { API_URL } from "@/lib/utils";
import request from "graphql-request";
import { TIER_QUERY, TIERS_QUERY } from "../graphql/tierQuery";

type PaginationParams = {
  limit?: number;
  offset?: number;
};

export const fetchTier = async (
  id: string,
  { limit, offset }: PaginationParams = {},
) => {
  return await request(API_URL, TIER_QUERY, { id, limit, offset });
};

export const fetchTiers = async () => {
  return await request(API_URL, TIERS_QUERY);
};
