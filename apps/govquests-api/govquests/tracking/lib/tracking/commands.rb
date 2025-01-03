module Tracking
  class CreateTrack < Infra::Command
    attribute :track_id, Infra::Types::UUID
    attribute :display_data, Infra::Types::Hash

    alias_method :aggregate_id, :track_id
  end

  class AssociateQuestWithTrack < Infra::Command
    attribute :track_id, Infra::Types::UUID
    attribute :quest_id, Infra::Types::UUID
    attribute :position, Infra::Types::Integer

    alias_method :aggregate_id, :track_id
  end
end