import { API_URL } from "@/lib/utils";
import request from "graphql-request";
import { SpecialBadgeQuery } from "../graphql/specialBadgeQuery";
import { SpecialBadgesQuery } from "../graphql/specialBadgesQuery";

export const fetchSpecialBadge = async (id: string) => {
  return await request(API_URL, SpecialBadgeQuery, { id });
};

export const fetchAllSpecialBadges = async () => {
  return await request(API_URL, SpecialBadgesQuery);
};
