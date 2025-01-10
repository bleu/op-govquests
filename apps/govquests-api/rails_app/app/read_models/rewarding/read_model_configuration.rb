module Rewarding
  class ReadModelConfiguration
    def call(event_store)
      event_store.subscribe(OnRewardPoolCreated, to: [Rewarding::RewardPoolCreated])
      event_store.subscribe(OnRewardIssued, to: [Rewarding::RewardIssued])
      event_store.subscribe(OnQuestCreated, to: [Questing::QuestCreated])
      event_store.subscribe(OnTrackCreated, to: [Questing::TrackCreated])
    end
  end
end
