import { Toaster } from "@/components/ui/toaster";
import { useToast } from "@/hooks/use-toast";
import { useNotifications } from "../hooks/useNotifications";
import { useEffect, useRef } from "react";

const NotificationToaster = () => {
  const { toast } = useToast();

  const { data } = useNotifications();

  const notifications = data?.pages.flatMap((page) => page.notifications.edges);
  const prevNotifications: typeof notifications = usePrevious(notifications);

  const toastNewNotification = () => {
    if (!!prevNotifications && notifications !== prevNotifications) {
      const newNotifications = notifications.filter(
        (notification) =>
          !prevNotifications.find(
            (value) => value.node.id == notification.node.id,
          ),
      );
      newNotifications.forEach((notification) => {
        if (notification?.node?.notificationType === "quest_completed") {
          toast({ title: notification?.node?.content });
        }
      });
    }
  };

  useEffect(toastNewNotification, [notifications]);

  return <Toaster />;
};

export default NotificationToaster;

function usePrevious(value) {
  const ref = useRef(null);
  useEffect(() => {
    ref.current = value;
  }, [value]);

  return ref.current;
}
