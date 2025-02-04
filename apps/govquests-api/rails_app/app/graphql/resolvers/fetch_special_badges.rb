module Resolvers
  class FetchSpecialBadges < BaseResolver
    type [Types::SpecialBadgeType], null: true

    def resolve
      Gamification::SpecialBadgeReadModel.all
    end
  end
end
