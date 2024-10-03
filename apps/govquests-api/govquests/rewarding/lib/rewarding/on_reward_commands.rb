module Rewarding
  class OnRewardCommands
    def initialize(event_store)
      @repository = Infra::AggregateRootRepository.new(event_store)
    end

    def call(command)
      @repository.with_aggregate(Reward, command.aggregate_id) do |reward|
        case command
        when CreateReward
          reward.create(command.reward_type, command.value, command.expiry_date)
        when IssueReward
          reward.issue(command.user_id)
        when ClaimReward
          reward.claim(command.user_id)
        end
      end
    end
  end
end
