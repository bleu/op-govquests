module Rewarding
  class OnTrackCreated
    def call(event)
      BadgeReadModel.create!(
        badge_id: SecureRandom.uuid,
        display_data: event.data[:badge_display_data],
        badgeable_type: "Questing::TrackReadModel",
        badgeable_id: event.data[:track_id]
      )
    end
  end
end
