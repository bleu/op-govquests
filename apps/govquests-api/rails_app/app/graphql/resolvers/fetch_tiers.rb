module Resolvers
  class FetchTiers < BaseResolver
    type [Types::TierType], null: false

    def resolve
      Gamification::TierReadModel.all
    end
  end
end
