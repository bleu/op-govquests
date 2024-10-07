export interface Quest {
  quest_id: string;
  actions: Action[];
  audience: "AllUsers" | "Delegates" | string;
  id: string;
  quest_type: "Onboarding" | "Governance" | string;
  rewards: Reward[];
  status: "created" | string;
  display_data: {
    intro: string;
    title: string;
    image_url: string;
  };
}

export type Action =
  | ReadDocumentAction
  | GitcoinScoreAction
  | ProposalVoteAction;

interface BaseAction {
  action_id: string;
  id: string;
  display_data: {
    content: string;
  };
}

export interface ReadDocumentAction extends BaseAction {
  action_type: "read_document";
  action_data: {
    document_url: string;
  };
}

export interface GitcoinScoreAction extends BaseAction {
  action_type: "gitcoin_score";
  action_data: {
    min_score: number;
  };
}

export interface ProposalVoteAction extends BaseAction {
  action_type: "proposal_vote";
  action_data: {
    proposal_id: string;
  };
}

export interface Reward {
  type: "Points" | string;
  amount: number;
}

export function isReadDocumentAction(
  action: Action
): action is ReadDocumentAction {
  return action.action_type === "read_document";
}

export function isGitcoinScoreAction(
  action: Action
): action is GitcoinScoreAction {
  return action.action_type === "gitcoin_score";
}

export function isProposalVoteAction(
  action: Action
): action is ProposalVoteAction {
  return action.action_type === "proposal_vote";
}
