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
          votingPower {
            totalVotingPower
            votingPowerRelativeToVotableSupply
          }
          user {
            address
            id
          }
        }
      }
    }
  }
`);

export const TIERS_QUERY = graphql(`
  query Tier {
    tiers {
      tierId
    }
  }
`);
