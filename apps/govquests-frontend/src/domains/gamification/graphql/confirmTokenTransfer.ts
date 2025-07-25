import { graphql } from "gql.tada";

export const CONFIRM_TOKEN_TRANSFER = graphql(`
  mutation ConfirmTokenTransfer(
    $userId: String!
    $poolId: String!
    $transactionHash: String!
  ) {
    confirmTokenTransfer(
      input: {
        userId: $userId
        poolId: $poolId
        transactionHash: $transactionHash
      }
    ) {
      success
      errors
    }
  }
`);
