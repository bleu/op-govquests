import request from "graphql-request";
import { START_ACTION_EXECUTION } from "../graphql/startActionExecution";
import { COMPLETE_ACTION_EXECUTION } from "../graphql/completeActionExecution";
import {
  StartActionExecutionVariables,
  StartActionExecutionResult,
  CompleteActionExecutionVariables,
  CompleteActionExecutionResult,
  ActionExecutionsQueryResult,
} from "../types/actionTypes";

const API_URL = "http://localhost:3000/graphql";

export const startActionExecution = async (
  variables: StartActionExecutionVariables,
): Promise<StartActionExecutionResult> => {
  return await request(API_URL, START_ACTION_EXECUTION, variables);
};

export const completeActionExecution = async (
  variables: CompleteActionExecutionVariables,
): Promise<CompleteActionExecutionResult> => {
  return await request(API_URL, COMPLETE_ACTION_EXECUTION, variables);
};
