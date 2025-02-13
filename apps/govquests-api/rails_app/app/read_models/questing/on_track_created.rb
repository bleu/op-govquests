module Questing
  class OnTrackCreated
    def call(event)
      track = TrackReadModel.find_or_initialize_by(
        track_id: event.data[:track_id]
      )

      track.update!(
        display_data: event.data[:display_data]
      )

      Rails.logger.info "Track created in read model: #{track.track_id}"
    end
  end
end
