module Questing
  class QuestCreated < Infra::Event
    attribute :quest_id, Infra::Types::UUID
    attribute :display_data, Infra::Types::Hash
    attribute :quest_type, Infra::Types::String
    attribute :audience, Infra::Types::String
    attribute :rewards, Infra::Types::Array
  end

  class ActionAssociatedWithQuest < Infra::Event
    attribute :quest_id, Infra::Types::UUID
    attribute :action_id, Infra::Types::UUID
    attribute :position, Infra::Types::Integer
  end
end
