import { useMutation, useQuery } from "@tanstack/react-query";
import { connectTelegram, isTelegramConnected } from "../notificationService";

export const useTelegramConnect = () => {
  return useMutation({
    mutationFn: connectTelegram,
  });
};

export const useIsTelegramConnected = () => {
  return useQuery({
    queryKey: ["isTelegramConnected"],
    queryFn: async () => {
      const { currentUser } = await isTelegramConnected();
      return !!currentUser.telegramChatId;
    },
    refetchInterval: (query) => (query.state.data === false ? 1000 : false),
    enabled: !!isTelegramConnected,
  });
};
