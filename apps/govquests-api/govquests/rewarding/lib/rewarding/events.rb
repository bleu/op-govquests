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

  class RewardClaimStarted < Infra::Event
    attribute :pool_id, Infra::Types::UUID
    attribute :user_id, Infra::Types::UUID
    attribute :reward_definition, Infra::Types::Hash
    attribute :claim_started_at, Infra::Types::Time
    attribute :claim_metadata, Infra::Types::Hash
  end

  class RewardClaimCompleted < Infra::Event
    attribute :pool_id, Infra::Types::UUID
    attribute :user_id, Infra::Types::UUID
    attribute :reward_definition, Infra::Types::Hash
    attribute :claim_completed_at, Infra::Types::Time
    attribute :claim_metadata, Infra::Types::Hash
  end
end
