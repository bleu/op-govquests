import request from "graphql-request";
import { NotificationsQuery } from "./graphql/notifications";
import { VariablesOf } from "gql.tada";

const API_URL =
  process.env.NEXT_PUBLIC_API_URL || "http://localhost:3000/graphql";

export const fetchNotifications = async (
  variables: VariablesOf<typeof NotificationsQuery>,
) => {
  return request(API_URL, NotificationsQuery, variables);
};
