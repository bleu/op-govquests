import { graphql } from "gql.tada";

export const QuestsQuery = graphql(`
  query GetQuests {
    quests {
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
      }
    }
  }
`);
