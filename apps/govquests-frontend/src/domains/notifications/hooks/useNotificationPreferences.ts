import type { CURRENT_USER } from "@/domains/authentication/graphql/currentUser";
import { fetchCurrentUser } from "@/domains/authentication/services/authService";
import { useQuery } from "@tanstack/react-query";
import type { ResultOf } from "gql.tada";

const getNotificationPreferences = async (
  currentUser: ResultOf<typeof CURRENT_USER>["currentUser"],
) => {
  return {
    telegramNotifications: currentUser.telegramNotifications,
    emailNotifications: currentUser.emailNotifications,
  };
};

export const useNotificationPreferences = () => {
  return useQuery({
    queryKey: ["notificationPreferences"],
    queryFn: async () => {
      const { currentUser } = await fetchCurrentUser();
      return getNotificationPreferences(currentUser);
    },
  });
};
