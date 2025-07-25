import { useMutation } from "@tanstack/react-query";
import { toast } from "../../../hooks/use-toast";
import { confirmTokenTransfer } from "../services/confirmTokenTransfer";

export const useConfirmTokenTransfer = (
  userId: string,
  poolId: string,
  transactionHash: string,
) => {
  return useMutation({
    mutationFn: () => confirmTokenTransfer(userId, poolId, transactionHash),
    onSuccess: (data) => {
      if (!data.confirmTokenTransfer.success) {
        toast({
          title: "Failed to confirm token transfer",
          description: data.confirmTokenTransfer.errors.map((value) => value),
        });
        return;
      }

      toast({
        title: "Token transfer confirmed",
      });
    },
    onError: () => {
      toast({
        title: "Failed to confirm token transfer",
      });
    },
  });
};
