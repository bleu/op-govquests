import { graphql } from "gql.tada";

export const QuestQuery = graphql(`
  query GetQuest($id: ID!) {
    quest(id: $id) {
      id
      questType
      audience
      rewards {
        type
        amount
      }
      displayData {
        title
        intro
        imageUrl
        requirements
      }
      userQuests {
        id
        status
        startedAt
        completedAt
      }
      actions {
        id
        actionType
        displayData {
            title
            description
        }
        actionData {
          documentUrl
          actionType
        }
        actionExecutions {
          id
          actionId
          userId
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
              address
              signature
              nonce
              score
              passedThreshold
            }
          }
        }
      }
    }
  }
`);
