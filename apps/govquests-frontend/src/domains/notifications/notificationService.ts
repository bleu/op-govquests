import request from "graphql-request";
import type { VariablesOf } from "gql.tada";
import { NotificationsQuery } from "./graphql/notifications";
import { API_URL } from "@/lib/utils";
import {
  ConnectTelegramMutation,
  IsTelegramConnectedQuery,
  UpdateNotificationPreferencesMutation,
} from "./graphql/telegram";

export const fetchNotifications = async (
  variables: VariablesOf<typeof NotificationsQuery>,
) => {
  return request(API_URL, NotificationsQuery, variables);
};

export const connectTelegram = async () => {
  return request(API_URL, ConnectTelegramMutation);
};

export const isTelegramConnected = async () => {
  return request(API_URL, IsTelegramConnectedQuery);
};

export const updateNotificationPreferences = async ({
  telegramNotifications,
  emailNotifications,
}: {
  telegramNotifications?: boolean;
  emailNotifications?: boolean;
}) => {
  return request(API_URL, UpdateNotificationPreferencesMutation, {
    telegramNotifications,
    emailNotifications,
  });
};
