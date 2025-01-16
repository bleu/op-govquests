module Questing
  class OnTrackCompleted
    def call(event)
      UserTrackReadModel.create_or_find_by!(
        user_id: event.data[:user_id],
        track_id: event.data[:track_id]
      ).update!(
        status: "completed",
        completed_at: Time.current
      )
    end
  end
end
