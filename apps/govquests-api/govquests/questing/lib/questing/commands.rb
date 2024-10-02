module Questing
  class CreateQuest < Infra::Command
    attribute :quest_id, Infra::Types::UUID
    attribute :audience, Infra::Types::String
    attribute :type, Infra::Types::String
    attribute :duration, Infra::Types::Integer
    attribute :difficulty, Infra::Types::String
    attribute :requirements, Infra::Types::Array.optional
    attribute :reward, Infra::Types::Hash.optional

    alias_method :aggregate_id, :quest_id
  end

  class AssociateActionWithQuest < Infra::Command
    attribute :quest_id, Infra::Types::UUID
    attribute :action_id, Infra::Types::UUID

    alias_method :aggregate_id, :quest_id
  end

  class UpdateQuestProgress < Infra::Command
    attribute :quest_id, Infra::Types::UUID
    attribute :user_id, Infra::Types::UUID
    attribute :action_id, Infra::Types::UUID

    alias_method :aggregate_id, :quest_id
  end
end
