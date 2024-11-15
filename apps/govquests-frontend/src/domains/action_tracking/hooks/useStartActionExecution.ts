import { useMutation, useQueryClient } from "@tanstack/react-query";
import { startActionExecution } from "../services/actionService";
import {
  StartActionExecutionResult,
  StartActionExecutionVariables,
} from "../types/actionTypes";

export const useStartActionExecution = () => {
  const queryClient = useQueryClient();
  return useMutation<
    StartActionExecutionResult,
    Error,
    StartActionExecutionVariables
  >({
    mutationFn: startActionExecution,
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["notifications"] });
    },
  });
};
