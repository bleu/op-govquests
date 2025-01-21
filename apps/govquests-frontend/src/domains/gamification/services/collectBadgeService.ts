import { API_URL } from "@/lib/utils";
import request from "graphql-request";
import { COLLECT_BADGE } from "../graphql/collectBadge";
import { CollectBadgeResult, CollectBadgeVariables } from "../types/badgeTypes";

export const collectBadge = async (
  variables: CollectBadgeVariables,
): Promise<CollectBadgeResult> => {
  return await request(API_URL, COLLECT_BADGE, variables);
};
