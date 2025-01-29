import { graphql } from "gql.tada";

export const TIER_QUERY = graphql(`
  query Tier($id: String!, $limit: Int, $offset: Int) {
    tier(id: $id) {
      imageUrl
      multiplier
      tierId
      displayData {
        description
        title
      }
      leaderboard {
        gameProfiles(limit: $limit, offset: $offset) {
          profileId
          rank
          score
          user {
            address
            id
          }
        }
      }
    }
  }
`);
