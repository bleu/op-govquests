module Questing
  class OnTrackCompleted
    def call(event)
      UserTrackReadModel.find_by!(
        user_track_id: event.data[:user_track_id]
      ).update!(
        status: "completed",
        completed_at: Time.current
      )
    end
  end
end
