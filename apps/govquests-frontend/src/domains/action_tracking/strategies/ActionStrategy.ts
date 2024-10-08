import { UseMutationResult } from "@tanstack/react-query";
import { ActionExecution } from "../types/actionTypes";
import { Action } from "@/domains/questing/types/questTypes";

export interface ActionStrategyProps {
  action: Action;
  execution: ActionExecution | null;
  startMutation: UseMutationResult<any, Error, any, unknown>;
  completeMutation: UseMutationResult<any, Error, any, unknown>;
  refetch: () => void;
}

export type ActionStrategy = React.FC<ActionStrategyProps>;
