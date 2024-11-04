module Processes
  class UpdateProfileOnRewardIssued
    def initialize(event_store, command_bus)
      @event_store = event_store
      @command_bus = command_bus
    end

    def subscribe
      @event_store.subscribe(self, to: [::Rewarding::RewardIssued])
    end

    def call(event)
      case event.data[:reward_definition]["type"]
      when "Points"
        handle_points_reward(event)
      when "Token"
        handle_token_reward(event)
      end
    end

    private

    def handle_points_reward(event)
      @command_bus.call(
        Gamification::UpdateScore.new(
          profile_id: event.data[:user_id],
          points: event.data[:reward_definition]["amount"]
        )
      )
    end

    def handle_token_reward(event)
      @command_bus.call(
        Gamification::AddTokenReward.new(
          profile_id: event.data[:user_id],
          token_address: event.data[:reward_definition]["token_address"],
          amount: event.data[:reward_definition]["amount"],
          pool_id: event.data[:pool_id]
        )
      )
    end
  end
end
