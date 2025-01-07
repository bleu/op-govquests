module Questing
  class QuestCreated < Infra::Event
    attribute :quest_id, Infra::Types::UUID
    attribute :display_data, Infra::Types::Hash
    attribute :audience, Infra::Types::String
  end

  class RewardPoolAssociated < Infra::Event
    attribute :quest_id, Infra::Types::UUID
    attribute :pool_id, Infra::Types::UUID
    attribute :reward_definition, SharedKernel::Types::RewardDefinition
  end

  class ActionAssociatedWithQuest < Infra::Event
    attribute :quest_id, Infra::Types::UUID
    attribute :action_id, Infra::Types::UUID
    attribute :position, Infra::Types::Integer
  end

  class QuestStarted < Infra::Event
    attribute :user_quest_id, Infra::Types::UUID
    attribute :quest_id, Infra::Types::UUID
    attribute :user_id, Infra::Types::UUID
  end

  class QuestCompleted < Infra::Event
    attribute :user_quest_id, Infra::Types::UUID
    attribute :quest_id, Infra::Types::UUID
    attribute :user_id, Infra::Types::UUID
  end

  class QuestProgressUpdated < Infra::Event
    attribute :user_quest_id, Infra::Types::UUID
    attribute :action_id, Infra::Types::UUID
    attribute :data, Infra::Types::Hash
  end

  # Tracks-related events
  class TrackCreated < Infra::Event
    attribute :track_id, Infra::Types::UUID
    attribute :display_data, Infra::Types::Hash
    attribute :quest_ids, Infra::Types::Array
    attribute :badge_id, Infra::Types::UUID
    attribute :badge_display_data, Infra::Types::Hash
  end
end
