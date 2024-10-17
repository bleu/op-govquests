import { useFetchQuest } from "@/domains/questing/hooks/useFetchQuest";
import { Action } from "@/domains/questing/types/questTypes";
import React from "react";
import { useCompleteActionExecution } from "../hooks/useCompleteActionExecution";
import { useStartActionExecution } from "../hooks/useStartActionExecution";
import { ActionStrategyFactory } from "../strategies/ActionStrategyFactory";

interface ActionHandlerProps {
  questId: string;
  action: Action;
}

const ActionHandler: React.FC<ActionHandlerProps> = ({ questId, action }) => {
  const { data, isLoading, refetch } = useFetchQuest(questId);

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
      questId={questId}
      action={action}
      execution={execution}
      refetch={refetch}
    />
  );
};

export default ActionHandler;
