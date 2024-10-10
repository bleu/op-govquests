import React from "react";
import { Action } from "@/domains/questing/types/questTypes";
import { useStartActionExecution } from "../hooks/useStartActionExecution";
import { useCompleteActionExecution } from "../hooks/useCompleteActionExecution";
import { useActionExecutions } from "../hooks/useActionExecutions";
import { ActionStrategyFactory } from "../strategies/ActionStrategyFactory";
import { ActionExecution } from "../types/actionTypes";

interface ActionHandlerProps {
  questId: string;
  action: Action;
}

const ActionHandler: React.FC<ActionHandlerProps> = ({ questId, action }) => {
  const {
    data: actionExecutions,
    isLoading: isFetchingExecutions,
    refetch,
  } = useActionExecutions(action.id);

  const execution = actionExecutions?.actionExecutions?.[0] || null;

  const startMutation = useStartActionExecution();
  const completeMutation = useCompleteActionExecution();

  const StrategyComponent = ActionStrategyFactory.createStrategy(
    action.actionType
  );

  if (isFetchingExecutions) {
    return <p>Loading action executions...</p>;
  }

  return (
    <StrategyComponent
      questId={questId}
      action={action}
      execution={execution}
      startMutation={startMutation}
      completeMutation={completeMutation}
      refetch={refetch}
    />
  );
};

export default ActionHandler;
