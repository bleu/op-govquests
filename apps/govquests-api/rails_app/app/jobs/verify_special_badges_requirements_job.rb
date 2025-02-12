class VerifySpecialBadgesRequirementsJob < ApplicationJob
  queue_as :default

  def perform
    Authentication::UserReadModel.find_each do |user|
      Gamification::SpecialBadgeReadModel.find_each do |badge|
        VerifySpecificBadgeForUserJob.perform_later(
          user_id: user.user_id,
          badge_id: badge.badge_id
        )
      end
    end
  end
end
