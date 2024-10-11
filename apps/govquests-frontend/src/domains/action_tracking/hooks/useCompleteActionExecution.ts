import { useMutation, useQueryClient } from "@tanstack/react-query";
import { completeActionExecution } from "../services/actionService";
import {
  CompleteActionExecutionVariables,
  CompleteActionExecutionResult,
} from "../types/actionTypes";

export const useCompleteActionExecution = (invalidateKey: string[]) => {
  const queryClient = useQueryClient();
  return useMutation<
    CompleteActionExecutionResult,
    Error,
    CompleteActionExecutionVariables
  >({
    mutationFn: completeActionExecution,
    onSuccess: (data, variables) => {
      queryClient.invalidateQueries({ queryKey: invalidateKey });
    },
  });
};
