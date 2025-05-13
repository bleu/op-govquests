import { useMutation, useQuery, useQueryClient } from "@tanstack/react-query";
import {
  getEmailVerificationStatus,
  sendEmailVerification,
} from "../notificationService";

export const useSendEmailVerification = () => {
  const queryClient = useQueryClient();

  return useMutation({
    mutationFn: sendEmailVerification,
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["emailVerificationStatus"] });
    },
  });
};

export const useEmailVerificationStatus = () => {
  return useQuery({
    queryKey: ["emailVerificationStatus"],
    queryFn: getEmailVerificationStatus,
  });
};
