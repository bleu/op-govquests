module Authentication
  class OnUserCommands
    def initialize(event_store)
      @repository = Infra::AggregateRootRepository.new(event_store)
    end

    def call(command)
      @repository.with_aggregate(User, command.aggregate_id) do |user|
        case command
        when RegisterUser
          user.register(command.email, command.user_type)
        when UpdateQuestProgress
          user.update_quest_progress(command.quest_id, command.progress_measure)
        when ClaimReward
          user.claim_reward(command.reward_id)
        when LogUserActivity
          user.log_activity(command.action_type, command.action_timestamp)
        end
      end
    end
  end
end
