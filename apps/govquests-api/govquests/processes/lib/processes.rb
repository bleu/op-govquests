require "infra"

require_relative "processes/start_quest_on_action_execution_started"
require_relative "processes/update_profile_on_reward_issued"
require_relative "processes/update_quest_progress_on_action_execution_completed"
require_relative "processes/distribute_rewards_on_quest_completed"

require_relative "processes/notify_on_quest_completed"
require_relative "processes/notify_on_reward_issued"
require_relative "processes/notify_on_badge_earned"
require_relative "processes/notify_on_tier_achieved"
require_relative "processes/create_badge_on_track_or_quest_created"
require_relative "processes/reward_badge_on_quest_completed"
require_relative "processes/complete_track_on_quest_completed"

require_relative "processes/deliver_notification_on_created"
module Processes
  class Configuration
    def call(event_store, command_bus)
      StartQuestOnActionExecutionStarted.new(event_store, command_bus).subscribe
      UpdateQuestProgressOnActionExecutionCompleted.new(event_store, command_bus).subscribe
      UpdateProfileOnRewardIssued.new(event_store, command_bus).subscribe
      DistributeRewardsOnQuestCompleted.new(event_store, command_bus).subscribe
      CreateBadgeOnTrackOrQuestCreated.new(event_store, command_bus).subscribe
      RewardBadgeOnQuestCompleted.new(event_store, command_bus).subscribe
      CompleteTrackOnQuestCompleted.new(event_store, command_bus).subscribe

      NotifyOnQuestCompleted.new(event_store, command_bus).subscribe
      NotifyOnRewardIssued.new(event_store, command_bus).subscribe
      NotifyOnBadgeEarned.new(event_store, command_bus).subscribe
      NotifyOnTierAchieved.new(event_store, command_bus).subscribe

      DeliverNotificationOnCreated.new(event_store, command_bus).subscribe   
    end
  end
end
