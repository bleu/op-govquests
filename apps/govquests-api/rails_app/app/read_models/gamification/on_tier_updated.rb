module Gamification
  class OnTierUpdated
    def call(event)
      tier = TierReadModel.find_by(
        tier_id: event.data[:tier_id]
      )

      tier.update!(
        display_data: event.data[:display_data],
        min_delegation: event.data[:min_delegation],
        max_delegation: event.data[:max_delegation],
        multiplier: event.data[:multiplier],
        image_url: event.data[:image_url]
      )

      leaderboard = LeaderboardReadModel.find_by(
        tier_id: tier.tier_id,
        leaderboard_id: tier.tier_id
      )

      leaderboard.update!(
        name: "#{tier.display_data["title"]} Leaderboard"
      )

      Rails.logger.info "Tier updated in read model: #{tier.tier_id}"
    end
  end
end
