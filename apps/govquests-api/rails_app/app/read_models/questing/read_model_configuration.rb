module Questing
  class ReadModelConfiguration
    def call(event_store)
      event_store.subscribe(OnQuestCreated, to: [Questing::QuestCreated])
      event_store.subscribe(OnActionAssociatedWithQuest, to: [Questing::ActionAssociatedWithQuest])
      event_store.subscribe(OnQuestStarted, to: [Questing::QuestStarted])
      event_store.subscribe(OnQuestCompleted, to: [Questing::QuestCompleted])
      event_store.subscribe(OnTrackCreated, to: [Questing::TrackCreated])
      event_store.subscribe(OnQuestAssociatedWithTrack, to: [Questing::QuestAssociatedWithTrack])
      event_store.subscribe(OnTrackStarted, to: [Questing::TrackStarted])
      event_store.subscribe(OnTrackCompleted, to: [Questing::TrackCompleted])
      event_store.subscribe(OnQuestUpdated, to: [Questing::QuestUpdated])
      event_store.subscribe(OnTrackUpdated, to: [Questing::TrackUpdated])
    end
  end
end
