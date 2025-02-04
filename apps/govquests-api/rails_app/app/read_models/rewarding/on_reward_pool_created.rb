module Rewarding
  class OnRewardPoolCreated
    def call(event)
      rewardable_class = event.data[:rewardable_type].constantize
      rewardable = case event.data[:rewardable_type]
      when "Questing::QuestReadModel"
        rewardable_class.find_by(quest_id: event.data[:rewardable_id])
      when "Gamification::SpecialBadgeReadModel"
        rewardable_class.find_by(badge_id: event.data[:rewardable_id])
      end

      RewardPoolReadModel.create!(
        pool_id: event.data[:pool_id],
        rewardable_id: rewardable.id,
        rewardable_type: event.data[:rewardable_type],
        reward_definition: event.data[:reward_definition],
        remaining_inventory: event.data[:initial_inventory]
      )
    end
  end
end
