import { useMutation } from "@tanstack/react-query";
import { refreshVotingPower } from "../services/refreshVotingPowerService";

export const useRefreshVotingPower = () => {
  return useMutation({
    mutationFn: refreshVotingPower,
  });
};