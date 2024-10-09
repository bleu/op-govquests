import { graphql } from "gql.tada";

export const SIGN_OUT = graphql(`
  mutation SignOut {
    signOut(input: {}) {
      success
    }
  }
`);
