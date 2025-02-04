module Resolvers
  class FetchBadges < BaseResolver
    type [Types::BadgeType], null: true

    def resolve
      Gamification::BadgeReadModel.all
    end
  end
end
