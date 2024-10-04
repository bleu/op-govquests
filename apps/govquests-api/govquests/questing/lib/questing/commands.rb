module Questing
  class CreateQuest < Infra::Command
    attribute :quest_id, Infra::Types::UUID
    attribute :title, Infra::Types::String
    attribute :intro, Infra::Types::String
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
