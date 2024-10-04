module Questing
  class CreateQuest < Infra::Command
    attribute :quest_id, Infra::Types::UUID
    attribute :display_data, Infra::Types::Hash
    attribute :quest_type, Infra::Types::String
    attribute :audience, Infra::Types::String
    attribute :rewards, Infra::Types::Array

    alias_method :aggregate_id, :quest_id
  end

  class AssociateActionWithQuest < Infra::Command
    attribute :quest_id, Infra::Types::UUID
    attribute :action_id, Infra::Types::UUID
    attribute :position, Infra::Types::Integer

    alias_method :aggregate_id, :quest_id
  end
end
