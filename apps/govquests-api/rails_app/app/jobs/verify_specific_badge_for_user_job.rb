class VerifySpecificBadgeForUserJob < ApplicationJob
  queue_as :default

  def perform(user_id:, badge_id:)
    badge = Gamification::SpecialBadgeReadModel.find_by(badge_id:)

    return if badge.user_badges.where(user_id: user_id).exists?

    Rails.configuration.command_bus.call(
      Gamification::UnlockSpecialBadge.new(
        badge_id: badge_id,
        user_id: user_id
      )
    )
  rescue => e
    Rails.logger.error "Failed to verify badge #{badge_id} for user #{user_id}: #{e.message}"
  end
end
