export type GitcoinScoreStatus =
  | "unstarted"
  | "started"
  | "verify"
  | "completed";

export type ReadDocumentStatus = "unstarted" | "started" | "completed";

export type VerifyPositionStatus = "unstarted" | "started" | "completed";

export type ActionType = "gitcoin_score" | "read_document" | "verify_position";
