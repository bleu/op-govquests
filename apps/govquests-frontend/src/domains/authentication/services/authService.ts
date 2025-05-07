import { GraphQLClient } from "graphql-request";
import { GENERATE_SIWE_MESSAGE } from "../graphql/generateSiweMessage";
import { SIGN_IN_WITH_ETHEREUM } from "../graphql/signInWithEthereum";
import { SIGN_OUT } from "../graphql/signOut";
import { CURRENT_USER } from "../graphql/currentUser";
import type { ResultOf, VariablesOf } from "gql.tada";
import { API_URL } from "@/lib/utils";

const client = new GraphQLClient(API_URL, {
  credentials: "include",
});

export const generateSiweMessage = async (
  variables: VariablesOf<typeof GENERATE_SIWE_MESSAGE>,
) => {
  return await client.request(GENERATE_SIWE_MESSAGE, variables);
};

export const signInWithEthereum = async (
  variables: VariablesOf<typeof SIGN_IN_WITH_ETHEREUM>,
) => {
  return await client.request(SIGN_IN_WITH_ETHEREUM, variables);
};

export const signOut = async () => {
  return await client.request(SIGN_OUT);
};

export const fetchCurrentUser = async (): Promise<
  ResultOf<typeof CURRENT_USER>
> => {
  return await client.request(CURRENT_USER);
};
