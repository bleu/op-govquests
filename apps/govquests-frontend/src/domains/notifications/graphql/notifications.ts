import { graphql } from "gql.tada";

export const NotificationsQuery = graphql(`
  query GetNotifications($first: Int!, $after: String, $readStatus: String) {
    notifications(first: $first, after: $after, readStatus: $readStatus) {
      edges {
        node {
          id
          title
          content
          notificationType
          status
          createdAt
          deliveries {
            edges {
              node {
                deliveryMethod
                status
                deliveredAt
                readAt
                metadata
              }
            }
          }
        }
        cursor
      }
      pageInfo {
        hasNextPage
        endCursor
      }
    }
    unreadNotificationsCount
  }
`);

export const MarkNotificationAsReadMutation = graphql(`
  mutation MarkNotificationAsRead($notificationId: ID!) {
    markNotificationAsRead(input: { notificationId: $notificationId }) {
      notificationDelivery {
        status
      }
      errors
    }
  }
`);

export const MarkAllNotificationsAsReadMutation = graphql(`
  mutation MarkAllNotificationsAsRead($deliveryMethod: String) {
    markAllNotificationsAsRead(input: { deliveryMethod: $deliveryMethod }) {
      success
      errors
    }
  }
`);
