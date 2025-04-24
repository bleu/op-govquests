import { API_URL } from "@/lib/utils";
import request from "graphql-request";
import {
  REFRESH_VOTING_POWER,
  type RefreshVotingPowerResult,
} from "../graphql/refreshVotingPower";

export const refreshVotingPower =
  async (): Promise<RefreshVotingPowerResult> => {
    return await request(API_URL, REFRESH_VOTING_POWER);
  };
