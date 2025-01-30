import { graphql } from "gql.tada";

export const CURRENT_USER_QUERY = graphql(`
  query CurrentUser {
    currentUser {
      address
      chainId
      email
      id
      userType
      gameProfile {
        profileId
        rank
        score
        tier {
          tierId
          imageUrl
          multiplier
          displayData {
            description
            title
          }
        }
      }
      userBadges {
        earnedAt
        userId
      }
      userQuests {
        completedAt
        id
        startedAt
        status
      }
    }
  }
`);

export const USER_QUERY = graphql(`
  query User($id: ID!) {
    user(id: $id) {
      address
      id
      userBadges {
        badge {
          __typename
          ... on Badge {
            id
            badgeable {
              __typename
            }
            displayData {
              sequenceNumber
              title
            }
          }
          ... on SpecialBadge {
            id
            displayData {
              sequenceNumber
              title
            }
          }
        }
        userId
        earnedAt
      }
      userQuests {
        completedAt
        id
        startedAt
        status
      }
      gameProfile {
        profileId
        rank
        score
        tier {
          multiplier
          imageUrl
          displayData {
            description
            title
          }
        }
      }
    }
  }
`);
