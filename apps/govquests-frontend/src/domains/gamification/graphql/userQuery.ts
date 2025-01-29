import { graphql } from "gql.tada";

export const USER_QUERY = graphql(`
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
      userTrack {
        completedAt
        id
        status
      }
    }
  }
`);
