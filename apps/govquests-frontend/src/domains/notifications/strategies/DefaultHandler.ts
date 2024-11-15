import { NotificationNode } from "../types/notificationTypes";
import { OnNotificationHandler } from "./OnNotificationHandler";

export class DefaultHandler implements OnNotificationHandler {
  handle(notification: NotificationNode) {
    console.log(
      `Unhandled notification type: ${notification.notificationType}`,
    );
  }
}
