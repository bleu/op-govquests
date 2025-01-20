import { graphql } from "gql.tada";

export const SpecialBadgeQuery = graphql(`
  query GetSpecialBadge($id: ID!) {
    specialBadge(id: $id) {
      id
      rewardPools {
        rewardDefinition {
          type
          amount
        }
      }
      badgeType
      earnedByCurrentUser
      displayData {
        title
        description
        imageUrl
      }
    }
  }
`);
