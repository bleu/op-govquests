import { API_URL } from "@/lib/utils";
import request from "graphql-request";
import { BadgeQuery } from "../graphql/badgeQuery";
import { BadgesQuery } from "../graphql/badgesQuery";

export const fetchBadge = async (id: string) => {
  return await request(API_URL, BadgeQuery, { id });
};

export const fetchAllBadges = async (special: boolean) => {
  return await request(API_URL, BadgesQuery, { special });
};
