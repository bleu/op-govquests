import { API_URL } from "@/lib/utils";
import { USER_QUERY } from "../graphql/userQuery";
import request from "graphql-request";

export const fetchUserInfo = async () => {
  return await request(API_URL, USER_QUERY);
};
