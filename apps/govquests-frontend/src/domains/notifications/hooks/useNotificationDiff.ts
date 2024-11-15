import { useEffect, useRef } from "react";
import { NotificationEdge } from "../types/notificationTypes";

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

function usePrevious<T>(value: T): T | null {
  const ref = useRef<T | null>(null);

  useEffect(() => {
    ref.current = value;
  }, [value]);

  return ref.current;
}
