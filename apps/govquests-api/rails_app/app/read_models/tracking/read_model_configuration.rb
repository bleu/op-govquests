module Tracking
  class ReadModelConfiguration
    def call(event_store)
      event_store.subscribe(OnTrackCreated, to: [TrackCreated])
      event_store.subscribe(OnQuestAssociatedWithTrack, to: [QuestAssociatedWithTrack])
    end
  end
end
