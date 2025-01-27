module Processes
  class DistributeRewardsOnBadgeEarned
    def initialize(event_store, command_bus)
      @event_store = event_store
      @command_bus = command_bus
    end

    def subscribe
      @event_store.subscribe(self, to: [::Gamification::BadgeEarned])
    end

    def call(event)
      badge_id = event.data[:badge_id]
      badge_type = event.data[:badge_type]
      user_id = event.data[:user_id]

      return unless badge_type == "Gamification::SpecialBadgeReadModel"

      badge = badge_type.constantize.find_by(badge_id: badge_id)
      return unless badge

      badge.reward_pools.each do |reward_pool|
        command = ::Rewarding::IssueReward.new(
          pool_id: reward_pool.pool_id,
          user_id: user_id
        )

        @command_bus.call(command)
      end
    end
  end
end
