import {
  useInfiniteQuery,
  useMutation,
  useQueryClient,
  useQuery,
} from "@tanstack/react-query";
import { fetchNotifications } from "../notificationService";

import { MarkNotificationAsReadMutation } from "../graphql/notifications";
import request from "graphql-request";

const API_URL =
  process.env.NEXT_PUBLIC_API_URL || "http://localhost:3000/graphql";

export const useNotifications = (readStatus?: string) => {
  return useInfiniteQuery({
    queryKey: ["notifications", readStatus],
    queryFn: ({ pageParam }) =>
      fetchNotifications({
        first: 10,
        after: pageParam as string | undefined,
        readStatus,
      }),
    getNextPageParam: (lastPage) =>
      lastPage.notifications.pageInfo.hasNextPage
        ? lastPage.notifications.pageInfo.endCursor
        : undefined,
    initialPageParam: undefined as string | undefined,
  });
};

export const useMarkNotificationAsRead = () => {
  const queryClient = useQueryClient();

  return useMutation({
    mutationFn: (notificationId: string) =>
      request(API_URL, MarkNotificationAsReadMutation, { notificationId }),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["notifications"] });
    },
  });
};

export const useUnreadCount = () => {
  return useQuery({
    queryKey: ["notifications", "unread-count"],
    queryFn: async () => {
      const data = await fetchNotifications({ first: 10 });
      return data.unreadNotificationsCount;
    },
    refetchInterval: 30000, // Refetch every 30 seconds
  });
};
