require_relative "test_helper"

module Processes
  class StartQuestOnActionExecutionStartedTest < Test
    cover "Processes::StartQuestOnActionExecutionStarted*"

    def test_inventory_available_error_is_raised
      quest_id = SecureRandom.uuid
      action_id = SecureRandom.uuid
      user_id = SecureRandom.uuid
      process = StartQuestOnActionExecutionStarted.new(command_bus)
      given([action_executed(quest_id, action_id, user_id)]).each do |event|
        process.call(event)
      end
      assert_command(::Questing::StartUserQuest.new(aggregate_id: SecureRandom.uuid, quest_id: quest_id, user_id: user_id))
    end

    private

    def action_executed(quest_id, action_id, user_id)
      ::ActionTracking::ActionExecutionStarted.new(data: {
        action_id: action_id,
        user_id: user_id,
        quest_id: quest_id
      })
    end
  end
end
