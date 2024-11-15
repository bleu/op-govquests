import { gql } from "graphql-request";
import {
  useInfiniteQuery,
  useMutation,
  useQueryClient,
  useQuery,
} from "@tanstack/react-query";
import request from "graphql-request";
import { fetchNotifications } from "../notificationService";
import {
  MarkAllNotificationsAsReadMutation,
  MarkNotificationAsReadMutation,
} from "../graphql/notifications";
import { API_URL } from "@/lib/utils";

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

export const useMarkAllNotificationsAsRead = () => {
  const queryClient = useQueryClient();

  return useMutation({
    mutationFn: (deliveryMethod: string = "in_app") =>
      request(API_URL, MarkAllNotificationsAsReadMutation, { deliveryMethod }),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["notifications"] });
      // Also invalidate the unread count
      queryClient.invalidateQueries({
        queryKey: ["notifications", "unread-count"],
      });
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
