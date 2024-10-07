import RewardIndicator from "@/components/RewardIndicator";
import Button from "@/components/ui/Button";
import type { Action, Quest } from "@/types/quest";
import { ExternalLink, MapIcon, RouteIcon } from "lucide-react";
import Link from "next/link";
import type React from "react";

interface QuestDetailsProps {
  quest: Pick<Quest, "display_data" | "actions" | "rewards">;
}

interface ActionRenderStrategy {
  render: (action: Action) => React.ReactNode;
}

const ReadDocumentStrategy: ActionRenderStrategy = {
  render: (action) => (
    <span className="flex items-center gap-2">
      {action.display_data.content}
      <Link
        href={(action.action_data as { document_url: string }).document_url}
      >
        <ExternalLink />
      </Link>
    </span>
  ),
};

const GitcoinScoreStrategy: ActionRenderStrategy = {
  render: (action) => (
    <span className="flex items-center gap-2">
      {action.display_data.content}
      <span className="text-sm text-gray-500">
        (Min score: {(action.action_data as { min_score: number }).min_score})
      </span>
    </span>
  ),
};

const ProposalVoteStrategy: ActionRenderStrategy = {
  render: (action) => (
    <span className="flex items-center gap-2">
      {action.display_data.content}
      <span className="text-sm text-gray-500">
        (Proposal ID:{" "}
        {(action.action_data as { proposal_id: string }).proposal_id})
      </span>
    </span>
  ),
};

const ActionRenderer: React.FC<{ action: Action }> = ({ action }) => {
  const strategies: Record<string, ActionRenderStrategy> = {
    read_document: ReadDocumentStrategy,
    gitcoin_score: GitcoinScoreStrategy,
    proposal_vote: ProposalVoteStrategy,
  };

  const strategy = strategies[action.action_type] || {
    render: () => <span>{action.display_data.content}</span>,
  };

  return <>{strategy.render(action)}</>;
};

const QuestDetails: React.FC<QuestDetailsProps> = ({ quest }) => {
  return (
    <main className="flex items-center justify-center h-full">
      <div className="flex flex-col max-w-[85%]">
        <div className="flex flex-1 items-center p-5 md:p-8 bg-black/60 text-optimismForeground rounded-lg mb-3">
          <MapIcon width={50} height={50} />
          <h1 className="text-3xl flex-1 ml-5">{quest.display_data.title}</h1>
          <div className="flex items-center">
            {quest.rewards.map((reward) => (
              <RewardIndicator key={reward.type} reward={reward} />
            ))}
          </div>
        </div>
        <div className="flex flex-col flex-1 justify-center bg-primary p-5 md:p-8 rounded-lg">
          <div className="flex items-center">
            <div className="w-24 h-24 bg-optimism" />
            <div className="ml-7">
              <h2 className="text-2xl font-medium mb-2">About this quest</h2>
              <p className="text-lg">{quest.display_data.intro}</p>
            </div>
          </div>
          <div className="flex items-center my-6">
            <RouteIcon width={30} height={30} />
            <h2 className="ml-4 text-xl font-bold">Steps to earn</h2>
          </div>
          <div className="flex flex-col md:flex-row">
            <div className="flex flex-col">
              {quest.actions.map((action) => (
                <div
                  className="flex flex-1 justify-between items-center mt-3"
                  key={action.id}
                >
                  <ActionRenderer action={action} />
                </div>
              ))}
            </div>
            <Button className="font-bold md:self-end md:ml-auto p-4">
              Complete quest
            </Button>
          </div>
        </div>
      </div>
    </main>
  );
};

export default QuestDetails;
