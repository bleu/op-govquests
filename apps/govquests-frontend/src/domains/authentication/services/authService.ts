import request from "graphql-request";
import { GENERATE_SIWE_MESSAGE } from "../graphql/generateSiweMessage";
import { SIGN_IN_WITH_ETHEREUM } from "../graphql/signInWithEthereum";
import { SIGN_OUT } from "../graphql/signOut";
import { CURRENT_USER } from "../graphql/currentUser";
import { ResultOf, VariablesOf } from "gql.tada";

const API_URL =
  process.env.NEXT_PUBLIC_API_URL || "http://localhost:3000/graphql";

export const generateSiweMessage = async (
  variables: VariablesOf<typeof GENERATE_SIWE_MESSAGE>,
) => {
  return await request(API_URL, GENERATE_SIWE_MESSAGE, variables);
};

export const signInWithEthereum = async (
  variables: VariablesOf<typeof SIGN_IN_WITH_ETHEREUM>,
) => {
  return await request(API_URL, SIGN_IN_WITH_ETHEREUM, variables);
};

export const signOut = async () => {
  return await request(API_URL, SIGN_OUT);
};

export const fetchCurrentUser = async (): Promise<
  ResultOf<typeof CURRENT_USER>
> => {
  return await request(API_URL, CURRENT_USER);
};
