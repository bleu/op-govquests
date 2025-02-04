import { API_URL } from "@/lib/utils";
import { CURRENT_USER_QUERY, USER_QUERY } from "../graphql/userQuery";
import request from "graphql-request";

export const fetchUserInfo = async () => {
  return await request(API_URL, CURRENT_USER_QUERY);
};

export const fetchUserById = async (id: string) => {
  return await request(API_URL, USER_QUERY, { id });
};
