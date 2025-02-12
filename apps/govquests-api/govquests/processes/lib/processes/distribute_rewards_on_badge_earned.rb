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

      badge = reconstruct_badge(badge_id)
      return unless badge

      badge.reward_pools.each do |reward_pool|
        command = ::Rewarding::IssueReward.new(
          pool_id: reward_pool,
          user_id: user_id
        )

        @command_bus.call(command)
      end
    end

    private 

    def reconstruct_badge(badge_id)
      stream_name = "Gamification::SpecialBadge$#{badge_id}"
      events = @event_store.read.stream(stream_name).to_a

      return nil if events.empty?

      badge = OpenStruct.new(reward_pools: [])

      events.each do |event|
        case event
        when ::Gamification::RewardPoolAssociated
          badge.reward_pools << event.data[:pool_id]
        end
      end

      badge
    end
  end
end
