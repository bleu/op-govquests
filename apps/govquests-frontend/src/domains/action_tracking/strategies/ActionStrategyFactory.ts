import type { ActionStrategy } from "./ActionStrategy";
import { DefaultStrategy } from "./DefaultStrategy";
import { DiscourseVerificationStrategy } from "./DiscourseVerificationStrategy";
import { EnsStrategy } from "./EnsStrategy";
import { GitcoinScoreStrategy } from "./GitcoinScoreStrategy";
import { ReadDocumentStrategy } from "./ReadDocumentStrategy";
import { SendEmailStrategy } from "./SendEmailStrategy";
import { VerifyAgora } from "./VerifyAgora";
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
      case "discourse_verification":
        return DiscourseVerificationStrategy;
      case "verify_position":
        return VerifyPositionStrategy;
      case "send_email":
        return SendEmailStrategy;
      case "verify_agora":
        return VerifyAgora;
      default:
        return DefaultStrategy;
    }
  }
}
