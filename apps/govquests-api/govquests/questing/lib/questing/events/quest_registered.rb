module Questing
  class QuestRegistered < Infra::Event
    attribute :quest_id, Infra::Types::UUID

  end
end
