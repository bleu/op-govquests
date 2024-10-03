module Rewarding
  class RewardCreated < Infra::Event
    attribute :reward_id, Infra::Types::UUID
    attribute :reward_type, Infra::Types::String
    attribute :value, Infra::Types::Integer
    attribute :expiry_date, Infra::Types::Time.optional
  end

  class RewardIssued < Infra::Event
    attribute :reward_id, Infra::Types::UUID
    attribute :user_id, Infra::Types::UUID
  end

  class RewardClaimed < Infra::Event
    attribute :reward_id, Infra::Types::UUID
    attribute :user_id, Infra::Types::UUID
  end

  class RewardExpired < Infra::Event
    attribute :reward_id, Infra::Types::UUID
  end

  class RewardInventoryDepleted < Infra::Event
    attribute :reward_id, Infra::Types::UUID
  end
end
