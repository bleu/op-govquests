import { Toaster } from "@/components/ui/toaster";
import { useToast } from "@/hooks/use-toast";
import { useEffect } from "react";
import { useNotificationDiff } from "../hooks/useNotificationDiff";
import { useNotifications } from "../hooks/useNotifications";
import { NotificationStrategyFactory } from "../strategies/NotificationStrategyFactory";
import { NotificationNode } from "../types/notificationTypes";

const NotificationToaster = () => {
  const { data } = useNotifications();
  const { toast } = useToast();

  const notifications = data?.pages?.flatMap(
    (value) => value.notifications.edges,
  );
  const { getNewNotifications } = useNotificationDiff(notifications);

  useEffect(() => {
    const newNotifications = getNewNotifications();

    newNotifications.forEach((notification) => {
      displayNotification(notification.node, toast);
    });
  }, [notifications]);

  return <Toaster />;
};

export default NotificationToaster;

const displayNotification = (
  notification: NotificationNode,
  toast: ReturnType<typeof useToast>["toast"],
) => {
  const notificationStrategy = NotificationStrategyFactory.createStrategy(
    notification.notificationType,
  );

  const { handleToast } = notificationStrategy({
    notification,
    toast,
  });

  handleToast();
};
