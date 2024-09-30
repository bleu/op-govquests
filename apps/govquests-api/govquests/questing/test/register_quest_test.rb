require_relative "test_helper"

module Questing
  class RegisterQuestTest < Test
    cover "Questing*"

    def setup
      @uid = SecureRandom.uuid
      @data = { quest_id: @uid, }
    end

    def test_quest_should_get_registered
      quest_registered = QuestRegistered.new(data: @data)
      assert_events("Questing::Quest$#{@uid}", quest_registered) do
        register_quest(@uid)
      end
    end

    def test_should_not_allow_for_double_registration
      assert_raises(Quest::AlreadyRegistered) do
        register_quest(@uid)
        register_quest(@uid)
      end
    end

    private

    def register_quest(quest_id)
      run_command(RegisterQuest.new(quest_id: quest_id))
    end
  end
end
