# frozen_string_literal: true

module Types
  class QueryType < Types::BaseObject
    field :node, Types::NodeType, null: true, description: "Fetches an object given its ID." do
      argument :id, ID, required: true, description: "ID of the object."
    end

    def node(id:)
      context.schema.object_from_id(id, context)
    end

    field :nodes, [Types::NodeType, null: true], null: true, description: "Fetches a list of objects given a list of IDs." do
      argument :ids, [ID], required: true, description: "IDs of the objects."
    end

    def nodes(ids:)
      ids.map { |id| context.schema.object_from_id(id, context) }
    end

    # Add root-level fields here.
    # They will be entry points for queries on your schema.
    field :quests, resolver: Resolvers::FetchQuests
    field :quest, resolver: Resolvers::FetchQuest

    field :track, resolver: Resolvers::FetchTrack
    field :tracks, resolver: Resolvers::FetchTracks

    field :badge, resolver: Resolvers::FetchBadge
    field :badges, resolver: Resolvers::FetchBadges

    field :special_badge, resolver: Resolvers::FetchSpecialBadge
    field :special_badges, resolver: Resolvers::FetchSpecialBadges

    field :tier, resolver: Resolvers::FetchTier
    field :tiers, resolver: Resolvers::FetchTiers

    field :current_user, resolver: Resolvers::CurrentUser, preauthorize: {with: AuthenticatedGraphqlPolicy}
    field :user, resolver: Resolvers::FetchUser

    field :reward_issuance, resolver: Resolvers::FetchRewardIssuance

    field :notifications,
      resolver: Resolvers::FetchNotifications,
      preauthorize: {with: AuthenticatedGraphqlPolicy}

    field :unread_notifications_count,
      resolver: Resolvers::UnreadNotificationsCount,
      preauthorize: {with: AuthenticatedGraphqlPolicy}
  end
end
