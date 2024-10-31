import { graphql } from "gql.tada";

export const QuestsQuery = graphql(`
  query GetQuests {
    quests {
      id
      audience
      status
      rewardPools {
        rewardDefinition {
          type
          amount
        }
        remainingInventory
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
          title
          description
        }
      }
    }
  }
`);
