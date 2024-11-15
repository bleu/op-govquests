import { NotificationEdge } from "../types/notificationTypes";
import { usePrevious } from "./usePrevious";

export const useNotificationDiff = (notifications: NotificationEdge[]) => {
  const prevNotifications = usePrevious(notifications);

  const getNewNotifications = () => {
    if (!prevNotifications) return [];

    return notifications.filter(
      (notification) =>
        !prevNotifications.find(
          (value) => value.node.id === notification.node.id,
        ),
    );
  };

  return { getNewNotifications };
};
