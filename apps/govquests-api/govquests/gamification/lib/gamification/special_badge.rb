module Gamification
  class SpecialBadge
    include AggregateRoot

    class VerificationFailedError < StandardError; end

    class AlreadyCreated < StandardError; end

    class RewardPoolAlreadyAssociatedError < StandardError; end

    attr_reader :unlocked_by

    def initialize(id)
      @id = id
      @display_data = nil
      @badge_type = nil
      @badge_data = nil
      @reward_pools = {}
      @unlocked_by = []
    end

    def create(display_data, badge_type, badge_data)
      raise AlreadyCreated if @display_data.present?
      apply SpecialBadgeCreated.new(data: {
        badge_id: @id,
        display_data:,
        badge_type:,
        badge_data:
      })
    end

    def update(display_data, badge_data)
      apply SpecialBadgeUpdated.new(data: {
        badge_id: @id,
        display_data:,
        badge_data:
      })
    end

    def associate_reward_pool(pool_id, reward_definition)
      raise RewardPoolAlreadyAssociatedError if @reward_pools[reward_definition[:type]]

      apply RewardPoolAssociated.new(data: {
        badge_id: @id,
        pool_id:,
        reward_definition:
      })
    end

    def verify_completion?(user_id:, dry_run: false)
      strategy = Gamification::SpecialBadgeStrategyFactory.for(@badge_type, badge_data: @badge_data, user_id: user_id, unlocked_by: @unlocked_by)
      can_complete = strategy.verify_completion?

      if can_complete
        apply BadgeUnlocked.new(data: {
          badge_id: @id,
          user_id: user_id,
        }) unless dry_run

        @unlocked_by << user_id if dry_run
      end  
      
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

    on SpecialBadgeUpdated do |event|
      @display_data = event.data[:display_data]
      @badge_data = event.data[:badge_data]
    end

    on RewardPoolAssociated do |event|
      @reward_pools[event.data[:reward_definition][:type]] = event.data[:pool_id]
    end

    on BadgeUnlocked do |event|
      @unlocked_by << event.data[:user_id]
    end
  end
end
