import { useMutation, useQueryClient } from "@tanstack/react-query";
import {
  startActionExecution,
  completeActionExecution,
} from "../services/actionService";
import {
  StartActionExecutionVariables,
  CompleteActionExecutionVariables,
  StartActionExecutionResult,
  CompleteActionExecutionResult,
} from "../types/actionTypes";

interface UseActionExecutionReturn {
  startAction: (variables: StartActionExecutionVariables) => Promise<void>;
  completeAction: (
    variables: CompleteActionExecutionVariables,
  ) => Promise<void>;
  isLoading: boolean;
  isError: boolean;
  error: Error | null;
  isSuccess: boolean;
}

export const useActionExecution = (
  questId: string,
): UseActionExecutionReturn => {
  const queryClient = useQueryClient();

  const startMutation = useMutation<
    StartActionExecutionResult,
    Error,
    StartActionExecutionVariables
  >({ mutationFn: startActionExecution });

  const completeMutation = useMutation<
    CompleteActionExecutionResult,
    Error,
    CompleteActionExecutionVariables
  >({
    mutationFn: completeActionExecution,
    onSuccess: (data, variables) => {
      queryClient.invalidateQueries({ queryKey: ["quest", questId] });
    },
  });

  const startAction = async (variables: StartActionExecutionVariables) => {
    await startMutation.mutateAsync(variables);
  };

  const completeAction = async (
    variables: CompleteActionExecutionVariables,
  ) => {
    await completeMutation.mutateAsync(variables);
  };

  const isLoading = startMutation.isPending || completeMutation.isPending;
  const isError = startMutation.isError || completeMutation.isError;
  const error = startMutation.error || completeMutation.error;
  const isSuccess = startMutation.isSuccess || completeMutation.isSuccess;

  return { startAction, completeAction, isLoading, isError, error, isSuccess };
};
