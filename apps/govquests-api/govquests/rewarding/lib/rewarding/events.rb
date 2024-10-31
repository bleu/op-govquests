module Rewarding
  class RewardPoolCreated < Infra::Event
    attribute :pool_id, Infra::Types::UUID
    attribute :quest_id, Infra::Types::UUID
    attribute :reward_definition, Infra::Types::Hash
    attribute :initial_inventory, Infra::Types::Integer.optional
  end

  class RewardIssued < Infra::Event
    attribute :pool_id, Infra::Types::UUID
    attribute :user_id, Infra::Types::UUID
    attribute :reward_definition, Infra::Types::Hash
    attribute :issued_at, Infra::Types::Time
  end

  class RewardClaimed < Infra::Event
    attribute :pool_id, Infra::Types::UUID
    attribute :user_id, Infra::Types::UUID
    attribute :reward_definition, Infra::Types::Hash
    attribute :claimed_at, Infra::Types::Time
  end
end
