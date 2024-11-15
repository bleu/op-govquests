import { useToast } from "@/hooks/use-toast";
import { NotificationNode } from "../types/notificationTypes";

export interface OnNotificationHandlerProps {
  notification: NotificationNode;
  toast: ReturnType<typeof useToast>["toast"];
}

export interface OnNotificationHandler {
  handle(notification: NotificationNode): void;
}
