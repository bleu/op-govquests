module Tracking
  class TrackCreated < Infra::Event
    attribute :track_id, Infra::Types::UUID
    attribute :display_data, Infra::Types::Hash
  end

  class QuestAssociatedWithTrack < Infra::Event
    attribute :track_id, Infra::Types::UUID
    attribute :quest_id, Infra::Types::UUID
    attribute :position, Infra::Types::Integer
  end
end