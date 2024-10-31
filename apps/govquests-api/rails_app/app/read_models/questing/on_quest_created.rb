module Questing
  class OnQuestCreated
    def call(event)
      quest = QuestReadModel.create!(
        quest_id: event.data[:quest_id],
        audience: event.data[:audience],
        status: "created",
        display_data: event.data[:display_data]
      )
      Rails.logger.info "Quest created in read model: #{quest.quest_id}"
    end
  end
end
