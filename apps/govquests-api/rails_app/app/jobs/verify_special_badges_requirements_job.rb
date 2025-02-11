class VerifySpecialBadgesRequirementsJob < ApplicationJob
  queue_as :default

  def perform
    Authentication::UserReadModel.find_each do |user|
      Gamification::SpecialBadgeReadModel.find_each do |badge|
        next if badge.user_badges.where(user_id: user.user_id).exists?

        Rails.configuration.command_bus.call(
          Gamification::UnlockSpecialBadge.new(s
            badge_id: badge.badge_id,
            user_id: user.user_id
          )
        )
      end
    rescue => e
      Rails.logger.error "Failed to update voting power for user #{user.user_id}: #{e.message}"
      next
    end
  end
end
