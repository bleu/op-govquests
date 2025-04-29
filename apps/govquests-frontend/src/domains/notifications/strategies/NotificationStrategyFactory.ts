import type { useToast } from "@/hooks/use-toast";
import { BadgeEarnedHandler } from "./BadgeEarnedHandler";
import { DefaultHandler } from "./DefaultHandler";
import type { OnNotificationHandler } from "./OnNotificationHandler";

export class OnNotificationHandlerFactory {
  constructor(
    private toast: ReturnType<typeof useToast>["toast"],
    private triggerConfetti: () => void,
  ) {}

  createHandler(type: string): OnNotificationHandler {
    switch (type) {
      case "badge_earned":
      case "special_badge_earned":
        return new BadgeEarnedHandler(this.toast, this.triggerConfetti);
      default:
        return new DefaultHandler(this.toast);
    }
  }
}
