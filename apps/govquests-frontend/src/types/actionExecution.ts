// src/types/actionExecution.ts
import {
  COMPLETE_ACTION_EXECUTION,
  START_ACTION_EXECUTION,
} from "@/services/useActionExecution";
import { ResultOf, VariablesOf } from "gql.tada";

// Types for StartActionExecution
export type StartActionExecutionVariables = VariablesOf<
  typeof START_ACTION_EXECUTION
>;
export type StartActionExecutionResult = ResultOf<
  typeof START_ACTION_EXECUTION
>;
export type StartActionExecutionData = NonNullable<
  StartActionExecutionResult["startActionExecution"]
>;

// Types for CompleteActionExecution
export type CompleteActionExecutionVariables = VariablesOf<
  typeof COMPLETE_ACTION_EXECUTION
>;
export type CompleteActionExecutionResult = ResultOf<
  typeof COMPLETE_ACTION_EXECUTION
>;
export type CompleteActionExecutionData = NonNullable<
  CompleteActionExecutionResult["completeActionExecution"]
>;

// ActionExecution type
export interface ActionExecution {
  id: string;
  actionId: string;
  userId: string;
  actionType: string;
  startData: Record<string, any>;
  completionData?: Record<string, any>;
  status: string;
  nonce: string;
  startedAt: string;
  completedAt?: string;
}

// ActionData type
export interface ActionData {
  actionId: string;
  actionType: string;
  actionData: Record<string, any>;
  displayData: {
    content: string;
  };
}
