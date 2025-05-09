import { graphql } from "gql.tada";

export const START_ACTION_EXECUTION = graphql(`
  mutation StartActionExecution(
    $questId: ID!
    $actionId: ID!
    $actionType: String!
  ) {
    startActionExecution(
      input: { questId: $questId, actionId: $actionId, actionType: $actionType }
    ) {
      actionExecution {
        id
        actionId
        userId
        actionType
        startData {
          ... on GitcoinScoreStartData {
            message
            nonce
          }
          ... on DiscourseVerificationStartData {
            verificationUrl
          }
        }
        status
        nonce
        startedAt
      }
      errors
    }
  }
`);
