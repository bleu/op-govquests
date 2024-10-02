module Questing
  class OnQuestStatusUpdated
    def call(event)
      quest_id = event.data.fetch(:quest_id)
      status = event.data.fetch(:status)

      quest = Quest.find_by(quest_id: quest_id)
      quest.update_column(:status, status)
    end
  end
end
