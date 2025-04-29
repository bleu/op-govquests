import type { NotificationNode } from "../lib/types";
import type { useToast } from "@/hooks/use-toast";

export interface OnNotificationHandlerProps {
  notification: NotificationNode;
  toast: ReturnType<typeof useToast>["toast"];
  triggerConfetti: () => void;
}

export interface OnNotificationHandler {
  handle(notification: NotificationNode): void;
}
