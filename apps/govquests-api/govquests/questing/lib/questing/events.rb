module Questing
  class QuestCreated < Infra::Event
    attribute :quest_id, Infra::Types::UUID
    attribute :audience, Infra::Types::String
    attribute :quest_type, Infra::Types::String
    attribute :duration, Infra::Types::Integer
    attribute :difficulty, Infra::Types::String
    attribute :requirements, Infra::Types::Array.optional
    attribute :reward, Infra::Types::Hash.optional
    attribute :subquests, Infra::Types::Array.optional
  end

  class QuestRequirementAdded < Infra::Event
    attribute :quest_id, Infra::Types::UUID
    attribute :requirement, Infra::Types::Hash
  end

  class SubquestAdded < Infra::Event
    attribute :quest_id, Infra::Types::UUID
    attribute :subquest, Infra::Types::Hash
  end

  class ActionAssociatedWithQuest < Infra::Event
    attribute :quest_id, Infra::Types::UUID
    attribute :action_id, Infra::Types::UUID
  end
end
