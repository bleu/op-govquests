import request from "graphql-request";
import { NotificationsQuery } from "./graphql/notifications";
import { VariablesOf } from "gql.tada";
import { API_URL } from "@/lib/utils";

export const fetchNotifications = async (
  variables: VariablesOf<typeof NotificationsQuery>,
) => {
  return request(API_URL, NotificationsQuery, variables);
};
