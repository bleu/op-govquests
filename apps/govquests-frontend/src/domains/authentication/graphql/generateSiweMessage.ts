import { graphql } from "gql.tada";

export const GENERATE_SIWE_MESSAGE = graphql(`
  mutation GenerateSiweMessage($address: String!, $chainId: Int!) {
    generateSiweMessage(input: { address: $address, chainId: $chainId }) {
      message
      nonce
    }
  }
`);
