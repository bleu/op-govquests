import { graphql } from "gql.tada";

export const CURRENT_USER = graphql(`
  query CurrentUser {
    currentUser {
      id
      email
      address
      chainId
      telegramNotifications
      emailNotifications
      emailVerificationToken
    }
  }
`);
