import { graphql } from "gql.tada";

export const TracksQuery = graphql(`
  query GetTracks {
    tracks {
      id
      points
      displayData {
        title
        description
        backgroundGradient {
          fromColor
          toColor
        }
      }
      badge {
        id
        displayData {
          title
          imageUrl
        }
      }
      quests {
        id
        audience
        status
        slug
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
        userQuests {
          status
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
  }
`);
