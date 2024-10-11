module Questing
  class OnActionAssociatedWithQuest
    def call(event)
      quest = QuestReadModel.find_by(quest_id: event.data[:quest_id])
      action = ActionTracking::ActionReadModel.find_by(action_id: event.data[:action_id])

      QuestActionReadModel.create!(
        quest: quest,
        action: action,
        position: event.data[:position]
      )
      Rails.logger.info "Action associated with quest: Quest ID: #{quest.quest_id}, Action ID: #{action.action_id}"
    end
  end
end
