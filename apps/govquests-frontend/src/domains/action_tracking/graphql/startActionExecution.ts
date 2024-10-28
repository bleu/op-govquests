import { graphql } from "gql.tada";

export const START_ACTION_EXECUTION = graphql(`
  mutation StartActionExecution(
    $questId: ID!
    $actionId: ID!
    $actionType: String!
    $email: String
  ) {
    startActionExecution(
      input: { questId: $questId, actionId: $actionId, actionType: $actionType, email: $email }
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
          ... on SendEmailStartData {
            email
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
