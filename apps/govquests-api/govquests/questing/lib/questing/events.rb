# lib/questing/events.rb
module Questing
  class QuestCreated < Infra::Event
    attribute :quest_id, Infra::Types::UUID
  end
end
