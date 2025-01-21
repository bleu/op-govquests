import { useMutation, useQueryClient } from "@tanstack/react-query";
import { collectBadge } from "../services/collectBadgeService";
import { CollectBadgeResult, CollectBadgeVariables } from "../types/badgeTypes";

export const useCollectBadge = () => {
  const queryClient = useQueryClient();
  return useMutation<CollectBadgeResult, Error, CollectBadgeVariables>({
    mutationFn: collectBadge,
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["specialBadge"] });
      queryClient.invalidateQueries({ queryKey: ["specialBadges"] });
    },
  });
};
