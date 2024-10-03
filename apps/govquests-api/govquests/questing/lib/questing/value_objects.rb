module Questing
  class QuestAudience < Dry::Struct
    values :AllUsers, :Delegates, :NewUsers
  end

  class QuestType < Dry::Struct
    values :Standard, :Epic, :Legendary
  end

  class QuestStatus < Dry::Struct
    values :Created, :Started, :Completed, :Expired, :Archived
  end

  class QuestDifficulty < Dry::Struct
    values :Easy, :Medium, :Hard, :Expert
  end

  class QuestReward < Dry::Struct
    attribute :reward_type, Infra::Types::String
    attribute :reward_value, Infra::Types::Integer
  end

  class QuestRequirement < Dry::Struct
    attribute :quest_type, Infra::Types::String
    attribute :description, Infra::Types::String
  end
end
