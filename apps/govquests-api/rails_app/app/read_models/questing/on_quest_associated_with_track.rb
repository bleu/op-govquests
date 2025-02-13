module Questing
  class OnQuestAssociatedWithTrack
    def call(event)
      track_id = event.data[:track_id]
      quest_id = event.data[:quest_id]

      track_quest = TrackQuestReadModel.find_or_initialize_by(
        track_id:,
        quest_id:
      )

      track_quest.update!(
        position: event.data[:position]
      )

      Rails.logger.info "Quest associated with track: Track ID: #{track_id}, Quest ID: #{quest_id}"
    end
  end
end
