import { graphql } from "gql.tada";

export const CURRENT_USER = graphql(`
  query CurrentUser {
    currentUser {
      id
      address
      chainId
    }
  }
`);
