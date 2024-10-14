import { VariablesOf, ResultOf } from "gql.tada";
import { START_ACTION_EXECUTION } from "../graphql/startActionExecution";
import { COMPLETE_ACTION_EXECUTION } from "../graphql/completeActionExecution";

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
