import { ActionStrategy } from "./ActionStrategy";
import { EnsStrategy } from "./EnsStrategy";
import { GitcoinScoreStrategy } from "./GitcoinScoreStrategy";
import { ReadDocumentStrategy } from "./ReadDocumentStrategy";
import { VerifyPositionStrategy } from "./VerifyPositionStrategy";

// biome-ignore lint/complexity/noStaticOnlyClass: <explanation>
export class ActionStrategyFactory {
  static createStrategy(actionType: string): ActionStrategy {
    switch (actionType) {
      case "gitcoin_score":
        return GitcoinScoreStrategy;
      case "read_document":
        return ReadDocumentStrategy;
      case "ens":
        return EnsStrategy;
      case "verify_position":
        return VerifyPositionStrategy;
      default:
        throw new Error(`Unsupported action type: ${actionType}`);
    }
  }
}
