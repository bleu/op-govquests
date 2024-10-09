import { graphql } from "gql.tada";

export const SIGN_IN_WITH_ETHEREUM = graphql(`
  mutation SignInWithEthereum($signature: String!) {
    signInWithEthereum(input: { signature: $signature }) {
      user {
        id
      }
      errors
    }
  }
`);
