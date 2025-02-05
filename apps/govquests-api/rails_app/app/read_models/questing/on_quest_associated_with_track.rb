module Questing
  class OnQuestAssociatedWithTrack
    def call(event)
      track_id = event.data[:track_id]
      quest_id = event.data[:quest_id]

      Questing::TrackQuestReadModel.create!(
        track_id:,
        quest_id:,
        position: event.data[:position]
      )
      Rails.logger.info "Quest associated with track: Track ID: #{track_id}, Quest ID: #{quest_id}"
    end
  end
end
