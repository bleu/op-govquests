import { ActionStrategy } from "./ActionStrategy";
import { GitcoinScoreStrategy } from "./GitcoinScoreStrategy";
import { ReadDocumentStrategy } from "./ReadDocumentStrategy";
import { DefaultActionStrategy } from "./DefaultActionStrategy";

export class ActionStrategyFactory {
  static createStrategy(actionType: string): ActionStrategy {
    switch (actionType) {
      case "gitcoin_score":
        return GitcoinScoreStrategy;
      case "read_document":
        return ReadDocumentStrategy;
      default:
        return DefaultActionStrategy;
    }
  }
}
