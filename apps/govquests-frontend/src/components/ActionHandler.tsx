import React, { useState } from "react";
import { useMutation } from "@tanstack/react-query";
import { useSignMessage } from "wagmi";
import { graphql } from "gql.tada";
import request from "graphql-request";
import { ActionStrategyFactory } from "@/strategies/ActionStrategyFactory";
import { ActionData, ActionExecutionData } from "@/types/action";

const START_ACTION_EXECUTION = graphql(`
  mutation StartActionExecution($actionId: ID!, $startData: JSON) {
    startActionExecution(
      input: { actionId: $actionId, startData: $startData }
    ) {
      actionExecution {
        id
        actionId
        userId
        actionType
        startData
        status
        nonce
        startedAt
      }
      errors
    }
  }
`);

const COMPLETE_ACTION_EXECUTION = graphql(`
  mutation CompleteActionExecution(
    $executionId: ID!
    $nonce: String!
    $completionData: JSON
  ) {
    completeActionExecution(
      input: {
        executionId: $executionId
        nonce: $nonce
        completionData: $completionData
      }
    ) {
      actionExecution {
        id
        actionId
        userId
        actionType
        startData
        completionData
        status
        nonce
        startedAt
        completedAt
      }
      errors
    }
  }
`);

interface ActionHandlerProps {
  action: ActionData;
  onComplete: () => void;
}

export const ActionHandler: React.FC<ActionHandlerProps> = ({
  action,
  onComplete,
}) => {
  const [execution, setExecution] = useState<ActionExecutionData | null>(null);
  const { signMessage } = useSignMessage();

  const startMutation = useMutation({
    mutationFn: async (variables: any) => {
      return await request(
        "http://localhost:3001/graphql",
        START_ACTION_EXECUTION,
        variables
      );
    },
  });

  const completeMutation = useMutation({
    mutationFn: async (variables: any) => {
      return await request(
        "http://localhost:3001/graphql",
        COMPLETE_ACTION_EXECUTION,
        variables
      );
    },
    onSuccess: onComplete,
  });

  const strategy = ActionStrategyFactory.createStrategy(action.actionType);

  const handleStart = async () => {
    await strategy.start(startMutation, action);
    setExecution(startMutation.data?.startActionExecution?.actionExecution);
  };

  const handleComplete = async () => {
    if (!execution) return;

    let completionData = {};

    if (action.actionType === "gitcoin_score") {
      const signature = await signMessage({
        message: execution.startData.message,
      });
      completionData = { signature };
    }

    await strategy.complete(completeMutation, execution, completionData);
  };

  if (completeMutation.isSuccess) {
    return <p>Action completed successfully!</p>;
  }

  if (execution) {
    return (
      <div onClick={handleComplete}>
        {strategy.renderCompleteContent(execution)}
      </div>
    );
  }

  return <div onClick={handleStart}>{strategy.renderStartContent(action)}</div>;
};
