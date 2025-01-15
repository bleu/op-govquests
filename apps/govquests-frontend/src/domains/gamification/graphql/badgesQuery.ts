import { graphql } from "gql.tada";

export const BadgesQuery = graphql(`
  query GetBadges() {
    badges {
      id
    }
  }
`);
