import { useToast } from "@/hooks/use-toast";
import { useEffect } from "react";
import { useNotificationDiff } from "./useNotificationDiff";
import { useNotifications } from "./useNotifications";
import { OnNotificationHandlerFactory } from "../strategies/NotificationStrategyFactory";
import { useConfetti } from "@/components/ConfettiProvider";

export const useNotificationProcessor = () => {
  const { data } = useNotifications();
  const { toast } = useToast();
  const { triggerConfetti } = useConfetti();
  const factory = new OnNotificationHandlerFactory(toast, triggerConfetti);

  const notifications = data?.pages?.flatMap(
    (value) => value.notifications.edges,
  );
  const { getNewNotifications } = useNotificationDiff(notifications);

  // biome-ignore lint/correctness/useExhaustiveDependencies: <explanation>
  useEffect(() => {
    const newNotifications = getNewNotifications();

    for (const notification of newNotifications) {
      const handler = factory.createHandler(notification.node.notificationType);
      handler.handle(notification.node);
    }
  }, [notifications]);
};
