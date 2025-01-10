module Resolvers
  class FetchBadge < BaseResolver
    type Types::BadgeType, null: true

    argument :id, ID, required: true

    def resolve(id:)
      Rewarding::BadgeReadModel.find_by(badge_id: id)
    end
  end
end
