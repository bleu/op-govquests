import HtmlRender from "@/components/ui/HtmlRender";
import { NotificationNode } from "../types/notificationTypes";
import { OnNotificationHandler } from "./OnNotificationHandler";
import React from "react";

export class DefaultHandler implements OnNotificationHandler {
  constructor(private toast) {}

  handle(notification: NotificationNode) {
    const titleElement = React.createElement(HtmlRender, {
      content: notification.content,
      className: "font-bold text-foreground",
    });

    this.toast({ title: titleElement });
  }
}
