import { updateNotificationPreferences } from "../notificationService";
import { useMutation, useQueryClient } from "@tanstack/react-query";

export const useUpdateNotificationPreferences = () => {
  const queryClient = useQueryClient();

  return useMutation({
    mutationFn: updateNotificationPreferences,
    onSuccess: () => {
      queryClient.invalidateQueries({
        queryKey: ["notificationPreferences"],
      });
    },
  });
};
