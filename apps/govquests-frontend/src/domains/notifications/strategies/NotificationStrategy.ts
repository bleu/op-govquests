import { useToast } from "@/hooks/use-toast";
import { NotificationNode } from "../types/notificationTypes";

export interface NotificationStrategyProps {
  notification: NotificationNode;
  toast: ReturnType<typeof useToast>["toast"];
}

export interface NotificationStrategyReturn {
  handleToast: () => void;
}

export type NotificationStrategy = (
  props: NotificationStrategyProps,
) => NotificationStrategyReturn;
