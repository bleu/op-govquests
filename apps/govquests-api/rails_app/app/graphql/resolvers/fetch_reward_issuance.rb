module Resolvers
  class FetchRewardIssuance < BaseResolver
    type Types::RewardIssuanceType, null: true

    argument :pool_id, ID, required: true
    argument :user_id, ID, required: true

    def resolve(pool_id:, user_id:)
      Rewarding::RewardIssuanceReadModel.find_by(pool_id: pool_id, user_id: user_id)
    end
  end
end
