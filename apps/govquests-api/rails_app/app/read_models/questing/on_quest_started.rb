module Questing
  class OnQuestStarted
    def call(event)
      quest_id = event.data[:quest_id]
      user_id = event.data[:user_id]

      UserQuestReadModel.find_or_create_by(quest_id: quest_id, user_id: user_id).update(
        status: "started",
        started_at: Time.current
      )
    end
  end
end
