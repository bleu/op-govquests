module Tracking
  class OnQuestAssociatedWithTrack
    def call(event)
      TrackQuestReadModel.create!(
        track_id: event.data[:track_id],
        quest_id: event.data[:quest_id],
        position: event.data[:position]
      )
    end
  end
end
