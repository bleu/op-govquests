import { graphql, type ResultOf } from "gql.tada";

export type RefreshVotingPowerResult = ResultOf<typeof REFRESH_VOTING_POWER>;

export const REFRESH_VOTING_POWER = graphql(`
  mutation RefreshVotingPower {
    refreshVotingPower(input: {}) {
      votingPower {
        totalVotingPower
        votingPowerRelativeToVotableSupply
      }
      errors
    }
  }
`);
