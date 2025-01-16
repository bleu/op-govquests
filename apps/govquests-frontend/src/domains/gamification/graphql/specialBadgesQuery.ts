import { graphql } from "gql.tada";

export const SpecialBadgesQuery = graphql(`
  query GetSpecialBadges {
    specialBadges {
      id
    }
  }
`);
