module Resolvers
  class FetchSpecialBadge < BaseResolver
    type Types::SpecialBadgeType, null: true

    argument :id, ID, required: true

    def resolve(id:)
      Gamification::SpecialBadgeReadModel.find_by(badge_id: id)
    end
  end
end
