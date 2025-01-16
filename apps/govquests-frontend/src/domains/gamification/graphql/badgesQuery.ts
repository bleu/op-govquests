import { graphql } from "gql.tada";

export const BadgesQuery = graphql(`
  query GetBadges($special: Boolean) {
    badges(special: $special) {
      id
    }
  }
`);
