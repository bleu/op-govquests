import request from "graphql-request";
import type { VariablesOf } from "gql.tada";
import { NotificationsQuery } from "./graphql/notifications";
import { API_URL } from "@/lib/utils";

export const fetchNotifications = async (
  variables: VariablesOf<typeof NotificationsQuery>,
) => {
  return request(API_URL, NotificationsQuery, variables);
};
