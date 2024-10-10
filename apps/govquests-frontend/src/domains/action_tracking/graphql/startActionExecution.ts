import { graphql } from "gql.tada";

export const START_ACTION_EXECUTION = graphql(`
  mutation StartActionExecution(
    $questId: ID!
    $actionId: ID!
    $startData: JSON
  ) {
    startActionExecution(
      input: { questId: $questId, actionId: $actionId, startData: $startData }
    ) {
      actionExecution {
        id
        actionId
        userId
        actionType
        startData
        status
        nonce
        startedAt
      }
      errors
    }
  }
`);
