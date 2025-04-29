import type { NotificationNode } from "../lib/types";
import type { OnNotificationHandler } from "./OnNotificationHandler";
import { NOTIFICATION_TITLES_MAP } from "../lib/constants";
export class DefaultHandler implements OnNotificationHandler {
  constructor(private toast) {}

  handle(notification: NotificationNode) {
    this.toast({
      title: NOTIFICATION_TITLES_MAP[notification.notificationType],
      description: notification.content,
    });
  }
}
