import { API_URL } from "@/lib/utils";
import request from "graphql-request";
import { BadgeQuery } from "../graphql/badgeQuery";

export const fetchBadge = async (id: string) => {
  return await request(API_URL, BadgeQuery, { id });
};
