module Questing
  class OnQuestCreated
    def call(event)
      quest = QuestReadModel.create!(
        quest_id: event.data[:quest_id],
        quest_type: event.data[:quest_type],
        audience: event.data[:audience],
        rewards: event.data[:reward],
        status: "created",
        display_data: {
          title: event.data[:title],
          intro: event.data[:intro],
          image_url: event.data[:image_url]
        }
      )
      Rails.logger.info "Quest created in read model: #{quest.quest_id}"
    rescue ActiveRecord::RecordInvalid => e
      Rails.logger.error "Failed to create quest in read model: #{e.message}"
    end
  end
end