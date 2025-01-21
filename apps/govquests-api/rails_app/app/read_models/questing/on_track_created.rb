module Questing
  class OnTrackCreated
    def call(event)
      track = TrackReadModel.create!(
        track_id: event.data[:track_id],
        display_data: event.data[:display_data]
      )

      event.data[:quest_ids].each_with_index do |quest_id, index|
        QuestReadModel.find_by(quest_id: quest_id)&.update!(
          track_id: track.track_id
        )
      end
    end
  end
end
