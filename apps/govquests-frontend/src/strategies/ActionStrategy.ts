import { UseMutationResult } from "@tanstack/react-query";
import { ActionData, ActionExecution } from "../types/actionExecution";

export interface ActionStrategy {
  start(
    mutation: UseMutationResult<any, Error, any, unknown>,
    action: ActionData
  ): Promise<void>;
  complete(
    mutation: UseMutationResult<any, Error, any, unknown>,
    execution: ActionExecution,
    data: any
  ): Promise<void>;
  renderStartContent(action: ActionData): React.ReactNode;
  renderCompleteContent(execution: ActionExecution): React.ReactNode;
  getCompletionData(execution: ActionExecution, data: any): any;
}
