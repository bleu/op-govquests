import { useMutation } from "@tanstack/react-query";
import request from "graphql-request";
import {
  ActionData,
  ActionExecution,
  StartActionExecutionVariables,
  StartActionExecutionResult,
  CompleteActionExecutionVariables,
  CompleteActionExecutionResult,
} from "@/types/actionExecution";
import { graphql } from "gql.tada";

const API_URL = "http://localhost:3001/graphql";

export const START_ACTION_EXECUTION = graphql(`
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

export const COMPLETE_ACTION_EXECUTION = graphql(`
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

export const useActionExecution = () => {
  const startActionMutation = useMutation<
    StartActionExecutionResult,
    Error,
    StartActionExecutionVariables
  >({
    mutationFn: (variables) =>
      request(API_URL, START_ACTION_EXECUTION, variables),
  });

  const completeActionMutation = useMutation<
    CompleteActionExecutionResult,
    Error,
    CompleteActionExecutionVariables
  >({
    mutationFn: (variables) =>
      request(API_URL, COMPLETE_ACTION_EXECUTION, variables),
  });

  const startAction = async (action: ActionData): Promise<ActionExecution> => {
    const result = await startActionMutation.mutateAsync({
      actionId: action.actionId,
      startData: action.actionData,
    });

    if (result.startActionExecution?.errors?.length) {
      throw new Error(result.startActionExecution.errors[0]);
    }

    return result.startActionExecution?.actionExecution as ActionExecution;
  };

  const completeAction = async (
    execution: ActionExecution,
    completionData: Record<string, any>
  ): Promise<ActionExecution> => {
    const result = await completeActionMutation.mutateAsync({
      executionId: execution.id,
      nonce: execution.nonce,
      completionData,
    });

    if (result.completeActionExecution?.errors?.length) {
      throw new Error(result.completeActionExecution.errors[0]);
    }

    return result.completeActionExecution?.actionExecution as ActionExecution;
  };

  return {
    startAction,
    completeAction,
    startActionMutation,
    completeActionMutation,
  };
};
