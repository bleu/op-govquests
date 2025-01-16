import { graphql } from "gql.tada";

export const SpecialBadgeQuery = graphql(`
  query GetSpecialBadge($id: ID!) {
    specialBadge(id: $id) {
      id
      points
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
