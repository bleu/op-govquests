import { NotificationNode } from "../types/notificationTypes";
import { OnNotificationHandler } from "./OnNotificationHandler";

export class DefaultHandler implements OnNotificationHandler {
  constructor(private toast) {}

  handle(notification: NotificationNode) {
    this.toast({ title: notification.content });
  }
}
