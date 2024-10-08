import { useMutation } from "@tanstack/react-query";
import { startActionExecution } from "../services/actionService";
import {
  StartActionExecutionVariables,
  StartActionExecutionResult,
} from "../types/actionTypes";

export const useStartActionExecution = () => {
  return useMutation<
    StartActionExecutionResult,
    Error,
    StartActionExecutionVariables
  >({ mutationFn: startActionExecution });
};
