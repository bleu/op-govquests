module Questing
  class OnTrackCreated
    def call(event)
      track = TrackReadModel.create!(
        track_id: event.data[:track_id],
        display_data: event.data[:display_data],
        quest_ids: event.data[:quest_ids]
      )

      badge_id = SecureRandom.uuid
      Rewarding::BadgeReadModel.create!(
        badge_id: badge_id,
        display_data: event.data[:badge_display_data],
        badgeable: track
      )
    end
  end
end
