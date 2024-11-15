import { DefaultStrategy } from "./DefaultStrategy";
import { NotificationStrategy } from "./NotificationStrategy";
import { QuestCompletedStrategy } from "./QuestCompletedStrategy";

export class NotificationStrategyFactory {
  static createStrategy(notificationType: string): NotificationStrategy {
    switch (notificationType) {
      case "quest_completed":
        return QuestCompletedStrategy;
      default:
        return DefaultStrategy;
    }
  }
}
