import { graphql } from "gql.tada";

export const COMPLETE_ACTION_EXECUTION = graphql(`
  mutation CompleteActionExecution(
    $executionId: ID!
    $nonce: String!
    $actionType: String!
    $gitcoinScoreCompletionData: GitcoinScoreCompletionDataInput
    $discourseVerificationCompletionData: DiscourseVerificationCompletionDataInput
  ) {
    completeActionExecution(
      input: {
        executionId: $executionId
        nonce: $nonce
        actionType: $actionType
        gitcoinScoreCompletionData: $gitcoinScoreCompletionData
        discourseVerificationCompletionData: $discourseVerificationCompletionData
      }
    ) {
      actionExecution {
        id
        actionType
        status
        nonce
        startedAt
        completedAt
        startData {
          ... on GitcoinScoreStartData {
            message
            nonce
          }
          ... on DiscourseVerificationStartData {
            verificationUrl
          }
        }
        completionData {
          ... on GitcoinScoreCompletionData {
            score
            minimumPassingScore
          }
          ... on DiscourseVerificationCompletionData {
            discourseUsername
          }
        }
      }
      errors
    }
  }
`);
