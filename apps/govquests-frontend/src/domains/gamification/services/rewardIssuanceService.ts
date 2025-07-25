import { API_URL } from "@/lib/utils";
import request from "graphql-request";
import { REWARD_ISSUANCE_QUERY } from "../graphql/rewardIssuanceQuery";

export const fetchRewardIssuance = async (poolId: string, userId: string) => {
  return await request(API_URL, REWARD_ISSUANCE_QUERY, { poolId, userId });
};
