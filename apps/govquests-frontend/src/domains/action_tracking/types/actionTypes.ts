import { VariablesOf, ResultOf } from "gql.tada";
import { ACTION_EXECUTIONS_QUERY } from "../graphql/actionExecutionsQuery";
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

export type ActionExecutionsQueryVariables = VariablesOf<
  typeof ACTION_EXECUTIONS_QUERY
>;

export type ActionExecutionsQueryResult = ResultOf<
  typeof ACTION_EXECUTIONS_QUERY
>;

export type ActionExecution = NonNullable<
  ResultOf<typeof ACTION_EXECUTIONS_QUERY>["actionExecutions"]
>[number];
