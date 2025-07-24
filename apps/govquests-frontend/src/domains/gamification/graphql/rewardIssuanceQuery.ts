import { graphql } from "gql.tada";

export const REWARD_ISSUANCE_QUERY = graphql(`
  query RewardIssuance($poolId: ID!, $userId: ID!) {
    rewardIssuance(poolId: $poolId, userId: $userId) {
      id
      pool {
        id
        rewardDefinition {
          type
          amount
        }
        rewardable {
          __typename
          ... on SpecialBadge {
            badgeType
            displayData {
              title
              description
              imageUrl
            }
          }
        }
      }
      user {
        id
        address
      }
    }
  }
`);
