import { graphql } from "gql.tada";

export const COMPLETE_ACTION_EXECUTION = graphql(`
  mutation CompleteActionExecution(
    $executionId: ID!
    $nonce: String!
    $actionType: String!
    $gitcoinScoreCompletionData: GitcoinScoreCompletionDataInput
    $readDocumentCompletionData: ReadDocumentCompletionDataInput
  ) {
    completeActionExecution(
      input: {
        executionId: $executionId
        nonce: $nonce
        actionType: $actionType
        gitcoinScoreCompletionData: $gitcoinScoreCompletionData
        readDocumentCompletionData: $readDocumentCompletionData
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
        }
        completionData {
          ... on GitcoinScoreCompletionData {
            score
            minimumPassingScore
          }
        }
      }
      errors
    }
  }
`);
