import type { useToast } from "@/hooks/use-toast";
import { DefaultHandler } from "./DefaultHandler";
import type { OnNotificationHandler } from "./OnNotificationHandler";
import { QuestCompletedHandler } from "./QuestCompletedHandler";
import { BadgeEarnedHandler } from "./BadgeEarnedHandler";

export class OnNotificationHandlerFactory {
  constructor(
    private toast: ReturnType<typeof useToast>["toast"],
    private triggerConfetti: () => void,
  ) {}

  createHandler(type: string): OnNotificationHandler {
    switch (type) {
      case "quest_completed":
        return new QuestCompletedHandler(this.toast);
      case "badge_earned":
        return new BadgeEarnedHandler(this.toast, this.triggerConfetti);
      default:
        return new DefaultHandler(this.toast);
    }
  }
}
