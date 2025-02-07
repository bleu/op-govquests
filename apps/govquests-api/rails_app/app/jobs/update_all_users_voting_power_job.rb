class UpdateAllUsersVotingPowerJob < ApplicationJob
  queue_as :default

  def perform
    Authentication::UserReadModel.find_each do |user|
      Gamification::UpdateVotingPowerService.new.call(user_id: user.user_id)
    rescue => e
      Rails.logger.error "Failed to update voting power for user #{user.user_id}: #{e.message}"
      next
    end
  end
end
