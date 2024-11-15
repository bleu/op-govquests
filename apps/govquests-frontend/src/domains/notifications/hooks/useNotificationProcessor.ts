import { useToast } from "@/hooks/use-toast";
import { useEffect } from "react";
import { useNotificationDiff } from "./useNotificationDiff";
import { useNotifications } from "./useNotifications";
import { OnNotificationHandlerFactory } from "../strategies/NotificationStrategyFactory";

export const useNotificationProcessor = () => {
  const { data } = useNotifications();
  const { toast } = useToast();
  const factory = new OnNotificationHandlerFactory(toast);

  const notifications = data?.pages?.flatMap(
    (value) => value.notifications.edges,
  );
  const { getNewNotifications } = useNotificationDiff(notifications);

  useEffect(() => {
    const newNotifications = getNewNotifications();

    newNotifications.forEach((notification) => {
      const handler = factory.createHandler(notification.node.notificationType);
      handler.handle(notification.node);
    });
  }, [notifications]);
};
