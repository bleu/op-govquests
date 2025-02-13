module Questing
  class OnQuestUpdated
    def call(event)
      quest = QuestReadModel.find_by(
        quest_id: event.data[:quest_id]
      )

      quest.update!(
        audience: event.data[:audience],
        display_data: event.data[:display_data]
      )

      Rails.logger.info "Quest updated in read model: #{quest.quest_id}"
    end
  end
end
