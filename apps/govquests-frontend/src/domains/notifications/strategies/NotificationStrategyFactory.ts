import { useToast } from "@/hooks/use-toast";
import { DefaultHandler } from "./DefaultHandler";
import { OnNotificationHandler } from "./OnNotificationHandler";
import { QuestCompletedHandler } from "./QuestCompletedHandler";

export class OnNotificationHandlerFactory {
  constructor(private toast: ReturnType<typeof useToast>["toast"]) {}

  createHandler(type: string): OnNotificationHandler {
    switch (type) {
      case "quest_completed":
        return new QuestCompletedHandler(this.toast);
      default:
        return new DefaultHandler(this.toast);
    }
  }
}
