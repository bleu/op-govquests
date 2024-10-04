module Questing
  class QuestCreated < Infra::Event
    attribute :quest_id, Infra::Types::UUID
    attribute :title, Infra::Types::String
    attribute :intro, Infra::Types::String
    attribute :quest_type, Infra::Types::String
    attribute :audience, Infra::Types::String
    attribute :reward, Infra::Types::Hash
  end

  class ActionAssociatedWithQuest < Infra::Event
    attribute :quest_id, Infra::Types::UUID
    attribute :action_id, Infra::Types::UUID
    attribute :position, Infra::Types::Integer
  end
end
