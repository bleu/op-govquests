import { graphql } from "gql.tada";

export const BadgesQuery = graphql(`
  query GetBadges {
    badges {
      id
      earnedByCurrentUser
      displayData {
        sequenceNumber
      }
      badgeable {
        __typename
        ... on Quest {
          id
        }
        ... on Track {
          id
        }
      }
    }
  }
`);
