module Questing
  class OnTrackCreated
    def call(event)
      track = TrackReadModel.create(
        track_id: event.data[:track_id],
        display_data: event.data[:display_data]
      )

      Rails.logger.info "Track created in read model: #{track.track_id}"
    end
  end
end
