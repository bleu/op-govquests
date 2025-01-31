module Gamification
  class UpdateAllUsersVotingPowerJob
    def self.perform
      Authentication::UserReadModel.find_each do |user|
        UpdateVotingPowerService.new.call(user_id: user.user_id)
      rescue => e
        Rails.logger.error "Failed to update voting power for user #{user.user_id}: #{e.message}"
      end
    end
  end
end
