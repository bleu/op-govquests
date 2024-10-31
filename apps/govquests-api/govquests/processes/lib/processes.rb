require "infra"

require_relative "processes/start_quest_on_action_execution_started"
require_relative "processes/update_score_on_points_reward_issued"
require_relative "processes/update_quest_progress_on_action_execution_completed"
require_relative "processes/distribute_rewards_on_quest_completed"

module Processes
  class Configuration
    def call(event_store, command_bus)
      StartQuestOnActionExecutionStarted.new(event_store, command_bus).subscribe
      UpdateQuestProgressOnActionExecutionCompleted.new(event_store, command_bus).subscribe
      UpdateScoreOnPointsRewardIssued.new(event_store, command_bus).subscribe
      DistributeRewardsOnQuestCompleted.new(event_store, command_bus).subscribe
    end
  end
end
