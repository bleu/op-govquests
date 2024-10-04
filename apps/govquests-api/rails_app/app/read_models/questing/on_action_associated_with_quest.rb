module Questing
  class OnActionAssociatedWithQuest
    def call(event)
      quest = QuestReadModel.find_by(quest_id: event.data[:quest_id])
      action = ActionTracking::ActionReadModel.find_by(action_id: event.data[:action_id])

      if quest && action
        quest_action = QuestActionReadModel.create!(
          quest: quest,
          action: action,
          position: event.data[:position]
        )
        Rails.logger.info "Action associated with quest: Quest ID: #{quest.quest_id}, Action ID: #{action.action_id}"
      else
        Rails.logger.error "Failed to associate action with quest. Quest: #{event.data[:quest_id]}, Action: #{event.data[:action_id]}"
      end
    rescue ActiveRecord::RecordInvalid => e
      Rails.logger.error "Failed to create quest action association: #{e.message}"
    end
  end
end
