// src/components/ActionComponentFactory.tsx
import React from "react";
import { ActionStrategyFactory } from "../strategies/ActionStrategyFactory";
import { ActionData } from "../types/action";
import { useActionExecutionStore } from "../stores/actionExecutionStore";

interface ActionComponentProps {
  action: ActionData;
}

export const ActionComponentFactory: React.FC<ActionComponentProps> = ({
  action,
}) => {
  const { currentExecution, startAction, completeAction } =
    useActionExecutionStore();
  const strategy = ActionStrategyFactory.createStrategy(action.actionType);

  if (currentExecution && currentExecution.actionId === action.actionId) {
    return (
      <div onClick={() => completeAction({})}>
        {strategy.renderCompleteContent(currentExecution)}
      </div>
    );
  }

  return (
    <div onClick={() => startAction(action)}>
      {strategy.renderStartContent(action)}
    </div>
  );
};
