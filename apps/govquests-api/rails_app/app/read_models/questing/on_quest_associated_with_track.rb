module Questing
  class OnQuestAssociatedWithTrack
    def call(event)
      track = Questing::TrackReadModel.find_by(track_id: event.data[:track_id])
      quest = Questing::QuestReadModel.find_by(quest_id: event.data[:quest_id])

      Questing::TrackQuestReadModel.create!(
        track: track,
        quest: quest,
        position: event.data[:position]
      )
      Rails.logger.info "Quest associated with track: Track ID: #{track.track_id}, Quest ID: #{quest.quest_id}"
    end
  end
end
