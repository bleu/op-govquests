module Questing
  class OnTrackCreated
    def call(event)
      Rewarding::BadgeReadModel.create!(
        badge_id: event.data[:badge_id],
        display_data: event.data[:badge_display_data]
      )
      TrackReadModel.create!(
        track_id: event.data[:track_id],
        display_data: event.data[:display_data],
        quest_ids: event.data[:quest_ids],
        badge_id: event.data[:badge_id]
      )
    end
  end
end
