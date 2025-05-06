import { NOTIFICATION_TITLES_MAP } from "../lib/constants";
import type { NotificationNode } from "../lib/types";
import type { OnNotificationHandler } from "./OnNotificationHandler";

export class BadgeEarnedHandler implements OnNotificationHandler {
  constructor(
    private toast,
    private triggerConfetti,
  ) {}

  handle(notification: NotificationNode) {
    this.triggerConfetti();
    this.toast({
      title: NOTIFICATION_TITLES_MAP[notification.notificationType],
      description: notification.content,
    });
  }
}
