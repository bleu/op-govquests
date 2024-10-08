import { graphql } from "gql.tada";

export const QuestQuery = graphql(`
  query GetQuest($id: ID!) {
    quest(id: $id) {
      id
      questType
      audience
      status
      rewards {
        type
        amount
      }
      displayData {
        title
        intro
        imageUrl
      }
      actions {
        id
        actionType
        displayData {
          content
        }
        actionData
        actionExecutions {
          id
          actionId
          userId
          actionType
          startData
          completionData
          status
          nonce
          startedAt
          completedAt
        }
      }
    }
  }
`);
