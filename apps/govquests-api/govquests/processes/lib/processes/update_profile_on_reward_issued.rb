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
      return if event.data[:reward_definition]["type"] != "Points"

      @command_bus.call(
        Gamification::UpdateScore.new(
          profile_id: event.data[:user_id],
          points: event.data[:reward_definition]["amount"]
        )
      )
    end
  end
end
