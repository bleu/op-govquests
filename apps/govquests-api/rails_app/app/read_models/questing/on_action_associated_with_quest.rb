module Questing
  class OnActionAssociatedWithQuest
    def call(event)
      quest_id = event.data[:quest_id]
      action_id = event.data[:action_id]

      quest_action = QuestActionReadModel.find_or_initialize_by(
        quest_id: quest_id,
        action_id: action_id
      )

      quest_action.update!(
        position: event.data[:position]
      )
      Rails.logger.info "Action associated with quest: Quest ID: #{quest_id}, Action ID: #{action_id}"
    end
  end
end
