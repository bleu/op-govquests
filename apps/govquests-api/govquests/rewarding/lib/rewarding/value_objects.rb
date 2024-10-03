module Rewarding
  class RewardType < Dry::Struct
    values :Experience, :Attribute, :Points
  end

  class RewardValue < Dry::Struct
    attribute :amount, Infra::Types::Integer
  end

  class RewardExpiryDate < Dry::Struct
    attribute :expiry_date, Infra::Types::Time
  end

  class Amount < Dry::Struct
    attribute :value, Infra::Types::Integer
  end

  class RewardDeliveryStatus < Dry::Struct
    values :Pending, :Issued, :Claimed, :Expired
  end
end
