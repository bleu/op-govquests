class VerifySpecificBadgeForUserJob < ApplicationJob
  class SpecialBadgeUnlockVerificationError < StandardError; end

  queue_as :default

  def perform(user_id:, badge_id:)
    badge = Gamification::SpecialBadgeReadModel.find_by(badge_id:)

    raise "Badge #{badge_id} not found" unless badge

    return if badge.user_badges.where(user_id: user_id).exists?

    Rails.configuration.command_bus.call(
      Gamification::UnlockSpecialBadge.new(
        badge_id: badge_id,
        user_id: user_id
      )
    )
  rescue => e
    error_message = "Failed to verify badge #{badge_id} for user #{user_id}: #{e.message}"
    Rails.logger.error error_message

    Appsignal.send_error(SpecialBadgeUnlockVerificationError.new(error_message)) do |transaction|
      transaction.set_namespace("background_job")
      transaction.set_tags(
        job: self.class.name,
        queue: queue_name
      )
      transaction.set_params(
        user_id: user_id,
        badge_id: badge_id,
        original_error: e.class.name
      )
    end
  end
end
