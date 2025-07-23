import { API_URL } from "@/lib/utils";
import request from "graphql-request";
import { CONFIRM_TOKEN_TRANSFER } from "../graphql/confirmTokenTransfer";

export const confirmTokenTransfer = async (
  userId: string,
  poolId: string,
  transactionHash: string,
) => {
  await request(API_URL, CONFIRM_TOKEN_TRANSFER, {
    userId,
    poolId,
    transactionHash,
  });
};
