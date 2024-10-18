import type { ResultOf, VariablesOf } from "gql.tada";
import type { COMPLETE_ACTION_EXECUTION } from "../graphql/completeActionExecution";
import type { START_ACTION_EXECUTION } from "../graphql/startActionExecution";

export type StartActionExecutionVariables = VariablesOf<
  typeof START_ACTION_EXECUTION
>;
export type StartActionExecutionResult = ResultOf<
  typeof START_ACTION_EXECUTION
>;

export type CompleteActionExecutionVariables = VariablesOf<
  typeof COMPLETE_ACTION_EXECUTION
>;
export type CompleteActionExecutionResult = ResultOf<
  typeof COMPLETE_ACTION_EXECUTION
>;
