import { graphql } from "gql.tada";

export const TracksQuery = graphql(`
  query GetTracks {
    tracks {
      id
      points
      displayData {
        title
        description
      }
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
  }
`);
