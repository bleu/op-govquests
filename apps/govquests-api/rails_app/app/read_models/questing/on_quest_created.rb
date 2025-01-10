module Questing
  class OnQuestCreated
    def call(event)
      slug = event.data[:display_data][:title].downcase.tr(" ", "-")

      quest = QuestReadModel.create!(
        quest_id: event.data[:quest_id],
        slug: slug,
        audience: event.data[:audience],
        status: "created",
        display_data: event.data[:display_data]
      )

      badge_id = SecureRandom.uuid
      Rewarding::BadgeReadModel.create!(
        badge_id: badge_id,
        display_data: event.data[:badge_display_data],
        badgeable: quest
      )
      Rails.logger.info "Quest created in read model: #{quest.quest_id}"
    end
  end
end
