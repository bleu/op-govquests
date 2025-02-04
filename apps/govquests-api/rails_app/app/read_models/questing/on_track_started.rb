module Questing
  class OnTrackStarted
    def call(event)
      user_track_id = event.data[:user_track_id]
      track_id = event.data[:track_id]
      user_id = event.data[:user_id]

      UserTrackReadModel.find_or_create_by(user_track_id:, track_id:, user_id:).update(
        status: "in_progress"
      )
    end
  end
end
