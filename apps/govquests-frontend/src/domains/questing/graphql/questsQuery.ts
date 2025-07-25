import { graphql } from "gql.tada";

export const QuestsQuery = graphql(`
  query GetQuests {
    quests {
      id
      audience
      slug
      status
      rewardPools {
        rewardDefinition {
          type
          amount
        }
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
      userQuests {
        status
      }
    }
  }
`);
