import { graphql } from "gql.tada";

export const START_ACTION_EXECUTION = graphql(`
  mutation StartActionExecution(
    $questId: ID!
    $actionId: ID!
    $actionType: String!
    $sendEmailVerificationInput: SendEmailVerificationInput
  ) {
    startActionExecution(
      input: { questId: $questId, actionId: $actionId, actionType: $actionType, sendEmailVerificationInput: $sendEmailVerificationInput }
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
