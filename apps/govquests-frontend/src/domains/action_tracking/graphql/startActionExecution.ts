import { graphql } from "gql.tada";

export const START_ACTION_EXECUTION = graphql(`
  mutation StartActionExecution($actionId: ID!, $startData: JSON) {
    startActionExecution(
      input: { actionId: $actionId, startData: $startData }
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
