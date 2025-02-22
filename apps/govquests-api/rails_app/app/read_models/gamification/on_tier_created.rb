module Gamification
  class OnTierCreated
    def call(event)
      tier = TierReadModel.create!(
        tier_id: event.data[:tier_id],
        display_data: event.data[:display_data],
        min_delegation: event.data[:min_delegation],
        max_delegation: event.data[:max_delegation],
        multiplier: event.data[:multiplier],
        image_url: event.data[:image_url]
      )

      LeaderboardReadModel.create!(
        tier_id: tier.tier_id,
        leaderboard_id: tier.tier_id,
        name: "#{tier.display_data["title"]} Leaderboard"
      )

      Rails.logger.info "Tier created in read model: #{tier.tier_id}"
    end
  end
end
