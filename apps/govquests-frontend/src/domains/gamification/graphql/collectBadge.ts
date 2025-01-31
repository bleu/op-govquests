import { graphql } from "gql.tada";

export const COLLECT_BADGE = graphql(`
  mutation CollectBadge($badgeId: ID!, $badgeType: String!) {
    collectBadge(input: { badgeId: $badgeId, badgeType: $badgeType }) {
      badgeEarned
      errors
    }
  }
`);
