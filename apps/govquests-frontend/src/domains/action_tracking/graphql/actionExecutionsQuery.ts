import { graphql } from "gql.tada";

export const ACTION_EXECUTIONS_QUERY = graphql(`
  query GetActionExecutions($actionId: ID!) {
    actionExecutions(actionId: $actionId) {
      id
      actionId
      userId
      actionType
      startData
      completionData
      status
      nonce
      startedAt
      completedAt
    }
  }
`);
