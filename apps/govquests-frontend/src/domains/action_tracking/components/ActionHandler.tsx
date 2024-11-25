import { useFetchQuest } from "@/domains/questing/hooks/useFetchQuest";
import { Action, Quest } from "@/domains/questing/types/questTypes";
import React from "react";
import { useCompleteActionExecution } from "../hooks/useCompleteActionExecution";
import { useStartActionExecution } from "../hooks/useStartActionExecution";
import { ActionStrategyFactory } from "../strategies/ActionStrategyFactory";

interface ActionHandlerProps {
  questSlug: string;
  action: Action;
}

const ActionHandler: React.FC<ActionHandlerProps> = ({ questSlug, action }) => {
  const { data, isLoading, refetch } = useFetchQuest(questSlug);

  const quest = data?.quest || null;
  const actionExecutions = quest?.actions.find(
    (a) => a.id === action.id,
  )?.actionExecutions;

  const execution = actionExecutions?.[0] || null;

  const StrategyComponent = ActionStrategyFactory.createStrategy(
    action.actionType,
  );

  if (isLoading) {
    return <p>Loading action executions...</p>;
  }

  return (
    <StrategyComponent
      quest={quest}
      questId={quest.id}
      action={action}
      execution={execution}
      refetch={refetch}
    />
  );
};

export default ActionHandler;
