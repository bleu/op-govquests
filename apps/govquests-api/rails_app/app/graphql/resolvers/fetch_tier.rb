module Resolvers
  class FetchTier < BaseResolver
    type Types::TierType, null: true

    argument :id, String, required: true

    def resolve(id:)
      Gamification::TierReadModel.find_by(tier_id: id)
    end
  end
end
