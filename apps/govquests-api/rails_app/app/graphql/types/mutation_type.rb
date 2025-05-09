# frozen_string_literal: true

module Types
  class MutationType < Types::BaseObject
    # Action Tracking
    field :start_action_execution, mutation: Mutations::StartActionExecution, preauthorize: {with: AuthenticatedGraphqlPolicy}
    field :complete_action_execution, mutation: Mutations::CompleteActionExecution, preauthorize: {with: AuthenticatedGraphqlPolicy}

    # Authentication
    field :generate_siwe_message, mutation: Mutations::GenerateSiweMessage
    field :sign_in_with_ethereum, mutation: Mutations::SignInWithEthereum
    field :sign_out, mutation: Mutations::SignOut

    # Notifications
    field :mark_notification_as_read, mutation: Mutations::MarkNotificationAsRead, preauthorize: {with: AuthenticatedGraphqlPolicy}
    field :mark_all_notifications_as_read, mutation: Mutations::MarkAllNotificationsAsRead, preauthorize: {with: AuthenticatedGraphqlPolicy}

    field :update_notification_preferences, mutation: Mutations::UpdateNotificationPreferences, preauthorize: {with: AuthenticatedGraphqlPolicy}
    field :connect_telegram, mutation: Mutations::ConnectTelegram, preauthorize: {with: AuthenticatedGraphqlPolicy}

    # Special Badges
    field :collect_badge, mutation: Mutations::CollectBadge, preauthorize: {with: AuthenticatedGraphqlPolicy}

    # Voting Power
    field :refresh_voting_power, mutation: Mutations::RefreshVotingPower, preauthorize: {with: AuthenticatedGraphqlPolicy}
  end
end
