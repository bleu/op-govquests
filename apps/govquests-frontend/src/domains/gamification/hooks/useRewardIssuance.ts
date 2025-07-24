import { useQuery } from "@tanstack/react-query";
import { fetchRewardIssuance } from "../services/rewardIssuanceService";

export const useRewardIssuance = (poolId: string, userId: string) => {
  return useQuery({
    queryKey: ["reward-issuance", poolId, userId],
    queryFn: () => fetchRewardIssuance(poolId, userId),
  });
};
