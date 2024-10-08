import { ActionStrategy } from "./ActionStrategy";
import { DefaultActionStrategy } from "./DefaultActionStrategy";
import { GitcoinScoreStrategy } from "./GitcoinScoreStrategy";

export class ActionStrategyFactory {
  static createStrategy(actionType: string): ActionStrategy {
    switch (actionType) {
      case "gitcoin_score":
        return new GitcoinScoreStrategy();
      default:
        return new DefaultActionStrategy();
    }
  }
}
