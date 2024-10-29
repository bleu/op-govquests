export type GitcoinScoreStatus =
  | "unstarted"
  | "started"
  | "verify"
  | "completed";

export type ReadDocumentStatus = "unstarted" | "started" | "completed";

export type VerifyPositionStatus = "unstarted" | "started" | "completed";

export type DiscourseVerificationStatus = "unstarted" | "started" | "completed";

export type EnsStatus = "unstarted" | "completed";

export type SendEmailStatus = "unstarted" | "completed";

export type VerifyWalletStatus = "unstarted" | "completed";

export type VerifyDelegateStatus = "unstarted" | "completed";

export type ActionType =
  | "gitcoin_score"
  | "read_document"
  | "verify_position"
  | "ens"
  | "discourse_verification"
  | "send_email"
  | "wallet_verification"
  | "verify_delegate";
