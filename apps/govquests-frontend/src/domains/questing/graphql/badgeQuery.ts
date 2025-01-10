import { graphql } from "gql.tada";

export const BadgeQuery = graphql(`
  query GetBadge($id: ID!) {
    badge(id: $id) {
      id
      displayData {
        title
        description
        imageUrl
      }
    }
  }
`);
