module Rewarding
  class OnQuestCreated
    def call(event)
      BadgeReadModel.create!(
        badge_id: SecureRandom.uuid,
        display_data: event.data[:badge_display_data],
        badgeable_type: "Questing::QuestReadModel",
        badgeable_id: event.data[:quest_id]
      )
    end
  end
end
