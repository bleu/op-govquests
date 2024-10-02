module ClientAuthentication
  class UpdateUserQuestProgress
    def call(event)
      user_id = event.data.fetch(:user_id)
      quest_id = event.data.fetch(:quest_id)
      progress_measure = event.data.fetch(:progress_measure)

      user = User.find_by(user_id: user_id)
      user&.update_columns(last_quest_id: quest_id, progress_measure: progress_measure)
    end
  end
end
