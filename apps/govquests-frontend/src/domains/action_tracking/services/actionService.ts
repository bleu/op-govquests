import request from "graphql-request";
import { START_ACTION_EXECUTION } from "../graphql/startActionExecution";
import { COMPLETE_ACTION_EXECUTION } from "../graphql/completeActionExecution";
import {
  StartActionExecutionVariables,
  StartActionExecutionResult,
  CompleteActionExecutionVariables,
  CompleteActionExecutionResult,
} from "../types/actionTypes";
import { API_URL } from "@/lib/utils";

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
