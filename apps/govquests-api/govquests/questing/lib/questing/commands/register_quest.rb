module Questing
  class RegisterQuest < Infra::Command
    attribute :quest_id, Infra::Types::UUID

    alias aggregate_id quest_id
  end
end
