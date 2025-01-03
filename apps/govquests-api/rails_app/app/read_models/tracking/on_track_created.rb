module Tracking
  class OnTrackCreated
    def call(event)
      TrackReadModel.create!(
        track_id: event.data[:track_id],
        display_data: event.data[:display_data]
      )
    end
  end
end
