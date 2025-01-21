import { useMutation, useQueryClient } from "@tanstack/react-query";
import { completeActionExecution } from "../services/actionService";
import {
  CompleteActionExecutionResult,
  CompleteActionExecutionVariables,
} from "../types/actionTypes";

export const useCompleteActionExecution = (invalidateKey: string[]) => {
  const queryClient = useQueryClient();
  return useMutation<
    CompleteActionExecutionResult,
    Error,
    CompleteActionExecutionVariables
  >({
    mutationFn: completeActionExecution,
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: invalidateKey });
      queryClient.invalidateQueries({ queryKey: ["notifications"] });      
      queryClient.invalidateQueries({ queryKey: ["badge"] });

    },
  });
};
