module Questing
  class CreateQuest < Infra::Command
    attribute :quest_id, Infra::Types::UUID

    alias_method :aggregate_id, :quest_id
  end
end
