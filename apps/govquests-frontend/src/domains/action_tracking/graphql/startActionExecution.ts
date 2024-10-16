import { graphql } from "gql.tada";

export const START_ACTION_EXECUTION = graphql(`
  mutation StartActionExecution(
    $questId: ID!
    $actionId: ID!
    $actionType: String!
    $gitcoinScoreStartData: GitcoinScoreStartDataInput
    $readDocumentStartData: ReadDocumentStartDataInput
    $ensStartData: EnsStartDataInput
  ) {
    startActionExecution(
      input: {
        questId: $questId
        actionId: $actionId
        actionType: $actionType
        gitcoinScoreStartData: $gitcoinScoreStartData
        readDocumentStartData: $readDocumentStartData
        ensStartData: $ensStartData
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
