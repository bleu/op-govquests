import { graphql } from "gql.tada";

export const ConnectTelegramMutation = graphql(`
  mutation ConnectTelegram {
    connectTelegram(input: {}) {
      linkToChat
      errors
    }
  }
`);

export const IsTelegramConnectedQuery = graphql(`
  query IsTelegramConnected {
    currentUser {
      telegramChatId
    }
  }
`);

export const UpdateNotificationPreferencesMutation = graphql(`
  mutation UpdateNotificationPreferences($telegramNotifications: Boolean, $emailNotifications: Boolean) {
    updateNotificationPreferences(input: { telegramNotifications: $telegramNotifications, emailNotifications: $emailNotifications }) {
      errors
    }
  }
`);
