module Gamification
  class RewardType < Dry::Struct
    values :points, :experience, :badge, :token
  end

  class RewardDeliveryStatus < Dry::Struct
    values :pending, :issued, :claimed, :expired
  end
end
