require "infra"

require_relative "processes/start_quest_on_action_execution_started"
require_relative "processes/update_profile_on_reward_issued"
require_relative "processes/update_quest_progress_on_action_execution_completed"
require_relative "processes/distribute_rewards_on_quest_completed"
require_relative "processes/propose_token_claim_transaction"

module Processes
  class Configuration
    def call(event_store, command_bus)
      StartQuestOnActionExecutionStarted.new(event_store, command_bus).subscribe
      UpdateQuestProgressOnActionExecutionCompleted.new(event_store, command_bus).subscribe
      UpdateProfileOnRewardIssued.new(event_store, command_bus).subscribe
      DistributeRewardsOnQuestCompleted.new(event_store, command_bus).subscribe
      ProposeTokenClaimTransaction.new(event_store, command_bus).subscribe
    end
  end
end
