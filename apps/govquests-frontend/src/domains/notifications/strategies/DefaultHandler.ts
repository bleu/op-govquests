import type { NotificationNode } from "../lib/types";
import type { OnNotificationHandler } from "./OnNotificationHandler";

export class DefaultHandler implements OnNotificationHandler {
  constructor(private toast) {}

  handle(notification: NotificationNode) {
    this.toast({
      title: notification.title,
      description: notification.content,
    });
  }
}
