import { useMutation, useQueryClient } from "@tanstack/react-query";
import { refreshVotingPower } from "../services/refreshVotingPowerService";

export const useRefreshVotingPower = () => {
  const queryClient = useQueryClient();
  
  return useMutation({
    mutationFn: refreshVotingPower,
    onSuccess: () => {
      queryClient.invalidateQueries({
        queryKey: ["current-user-info"],
      });
      queryClient.invalidateQueries({
        queryKey: ["tier"],
      });
      queryClient.invalidateQueries({
        queryKey: ["tiers"],
      });
    },
  });
};