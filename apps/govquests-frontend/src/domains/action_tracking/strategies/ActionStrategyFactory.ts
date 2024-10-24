import type { ActionStrategy } from "./ActionStrategy";
import { DiscourseVerificationStrategy } from "./DiscourseVerificationStrategy";
import { EnsStrategy } from "./EnsStrategy";
import { GitcoinScoreStrategy } from "./GitcoinScoreStrategy";
import { ReadDocumentStrategy } from "./ReadDocumentStrategy";
import { SendEmailStrategy } from "./SendEmailStrategy";
import { VerifyPositionStrategy } from "./VerifyPositionStrategy";
import { VerifyWalletStrategy } from "./VerifyWalletStrategy";

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
      case "discourse_verification":
        return DiscourseVerificationStrategy;
      case "verify_position":
        return VerifyPositionStrategy;
      case "send_email":
        return SendEmailStrategy;
      case "wallet_verification":
        return VerifyWalletStrategy;
      default:
        throw new Error(`Unsupported action type: ${actionType}`);
    }
  }
}
