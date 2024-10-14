import { graphql } from "gql.tada";

export const START_ACTION_EXECUTION = graphql(`
  mutation StartActionExecution(
    $questId: ID!
    $actionId: ID!
    $actionType: String!
    $gitcoinScoreStartData: GitcoinScoreStartDataInput
    $readDocumentStartData: ReadDocumentStartDataInput
  ) {
    startActionExecution(
      input: {
        questId: $questId
        actionId: $actionId
        actionType: $actionType
        gitcoinScoreStartData: $gitcoinScoreStartData
        readDocumentStartData: $readDocumentStartData
      }
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
        }
        status
        nonce
        startedAt
      }
      errors
    }
  }
`);
