import { graphql } from "gql.tada";

export const COMPLETE_ACTION_EXECUTION = graphql(`
  mutation CompleteActionExecution(
    $executionId: ID!
    $nonce: String!
    $completionData: JSON
  ) {
    completeActionExecution(
      input: {
        executionId: $executionId
        nonce: $nonce
        completionData: $completionData
      }
    ) {
      actionExecution {
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
      errors
    }
  }
`);
