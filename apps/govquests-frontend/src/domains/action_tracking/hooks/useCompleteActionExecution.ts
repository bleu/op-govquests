import { useMutation } from "@tanstack/react-query";
import { completeActionExecution } from "../services/actionService";
import {
  CompleteActionExecutionVariables,
  CompleteActionExecutionResult,
} from "../types/actionTypes";

export const useCompleteActionExecution = () => {
  return useMutation<
    CompleteActionExecutionResult,
    Error,
    CompleteActionExecutionVariables
  >({ mutationFn: completeActionExecution });
};
