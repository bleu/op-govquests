require "infra"

require_relative "processes/start_quest_on_action_execution_started"
require_relative "processes/start_track_on_action_execution_started"

require_relative "processes/update_profile_on_reward_issued"
require_relative "processes/update_quest_progress_on_action_execution_completed"
require_relative "processes/distribute_rewards_on_quest_completed"
require_relative "processes/distribute_rewards_on_badge_earned"
require_relative "processes/create_game_profile_on_user_registered"

require_relative "processes/notify_on_quest_completed"
require_relative "processes/notify_on_reward_issued"
require_relative "processes/notify_on_badge_earned"
require_relative "processes/notify_on_tier_achieved"
require_relative "processes/create_badge_on_track_or_quest_created"
require_relative "processes/reward_badge_on_quest_or_track_completed"
require_relative "processes/update_track_on_quest_completed"

require_relative "processes/deliver_notification_on_created"
module Processes
  class Configuration
    def call(event_store, command_bus)
      StartQuestOnActionExecutionStarted.new(event_store, command_bus).subscribe
      StartTrackOnActionExecutionStarted.new(event_store, command_bus).subscribe
      
      UpdateQuestProgressOnActionExecutionCompleted.new(event_store, command_bus).subscribe
      UpdateProfileOnRewardIssued.new(event_store, command_bus).subscribe
      DistributeRewardsOnQuestCompleted.new(event_store, command_bus).subscribe
      CreateBadgeOnTrackOrQuestCreated.new(event_store, command_bus).subscribe
      RewardBadgeOnQuestOrTrackCompleted.new(event_store, command_bus).subscribe
      UpdateTrackOnQuestCompleted.new(event_store, command_bus).subscribe
      DistributeRewardsOnBadgeEarned.new(event_store, command_bus).subscribe
      CreateGameProfileOnUserRegistered.new(event_store, command_bus).subscribe

      NotifyOnQuestCompleted.new(event_store, command_bus).subscribe
      NotifyOnRewardIssued.new(event_store, command_bus).subscribe
      NotifyOnBadgeEarned.new(event_store, command_bus).subscribe
      NotifyOnTierAchieved.new(event_store, command_bus).subscribe

      DeliverNotificationOnCreated.new(event_store, command_bus).subscribe
    end
  end
end
