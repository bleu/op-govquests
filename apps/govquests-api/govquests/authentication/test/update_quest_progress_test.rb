require_relative "test_helper"

module Authentication
  class UpdateQuestProgressTest < Test
    cover "Authentication*"

    def setup
      @user_id = SecureRandom.uuid
      register_user(@user_id)
      @quest_id = SecureRandom.uuid
    end

    def test_user_can_update_quest_progress
      progress_measure = 5
      quest_progress_updated = QuestProgressUpdated.new(
        data: {user_id: @user_id, quest_id: @quest_id, progress_measure: progress_measure}
      )
      assert_events("Authentication::User$#{@user_id}", quest_progress_updated) do
        update_quest_progress(@user_id, @quest_id, progress_measure)
      end
    end

    private

    def register_user(user_id)
      run_command(RegisterUser.new(user_id: user_id, address: "0x", chain_id: 1))
    end

    def update_quest_progress(user_id, quest_id, progress_measure)
      run_command(UpdateQuestProgress.new(
        user_id: user_id,
        quest_id: quest_id,
        progress_measure: progress_measure
      ))
    end
  end
end
