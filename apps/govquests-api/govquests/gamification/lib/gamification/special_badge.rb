module Gamification
  class SpecialBadge
    include AggregateRoot

    class VerificationFailedError < StandardError; end

    def initialize(id)
      @id = id
      @display_data = nil
      @badge_type = nil
      @badge_data = nil
      @reward_pools = []
      @unlocked_by = []
    end

    def create(display_data, badge_type, badge_data)
      apply SpecialBadgeCreated.new(data: {
        badge_id: @id,
        display_data:,
        badge_type:,
        badge_data:
      })
    end

    def associate_reward_pool(pool_id, reward_definition)
      apply RewardPoolAssociated.new(data: {
        badge_id: @id,
        pool_id:,
        reward_definition:
      })
    end

    def verify_completion?(user_id:, dry_run: false)
      strategy = Gamification::SpecialBadgeStrategyFactory.for(@badge_type, badge_data: @badge_data, user_id: user_id)
      can_complete = strategy.verify_completion?

      apply BadgeUnlocked.new(data: {
        badge_id: @id,
        user_id: user_id
      }) unless dry_run or !can_complete
      
      can_complete
    end

    def collect_badge(user_id)
      raise VerificationFailedError unless verify_completion?(user_id: user_id, dry_run: true)

      Gamification.command_bus.call(
        EarnBadge.new(
          user_id: user_id,
          badge_id: @id,
          badge_type: "Gamification::SpecialBadgeReadModel"
        )
      )
    end

    private

    on SpecialBadgeCreated do |event|
      @display_data = event.data[:display_data]
      @badge_type = event.data[:badge_type]
      @badge_data = event.data[:badge_data]
    end

    on RewardPoolAssociated do |event|
      @reward_pools << {
        pool_id: event.data[:pool_id],
        reward_definition: event.data[:reward_definition]
      }
    end

    on BadgeUnlocked do |event|
      @unlocked_by << event.data[:user_id]
    end
  end
end
