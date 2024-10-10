module Questing
  class OnQuestCompleted
    def call(event)
      quest_id = event.data[:quest_id]
      user_id = event.data[:user_id]

      UserQuestReadModel.find_or_create_by(quest_id: quest_id, user_id: user_id).update!(
        status: "completed",
        completed_at: Time.current
      )
    end
  end
end
