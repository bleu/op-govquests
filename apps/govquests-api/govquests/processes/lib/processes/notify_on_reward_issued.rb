module Processes
  class NotifyOnRewardIssued
    def initialize(event_store, command_bus)
      @event_store = event_store
      @command_bus = command_bus
    end

    def subscribe
      @event_store.subscribe(self, to: [::Rewarding::RewardIssued])
    end

    def call(event)
      user_id = event.data[:user_id]
      reward = event.data[:reward_definition]

      content = case reward["type"]
      when "Points"
        "You've earned #{reward["amount"]} points!"
      when "Token"
        "You've earned #{reward["amount"]} tokens!"
      end

      @command_bus.call(
        ::Notifications::CreateNotification.new(
          notification_id: SecureRandom.uuid,
          user_id: user_id,
          content: content,
          notification_type: "reward_issued"
        )
      )
    end
  end
end
