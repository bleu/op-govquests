class UpdateAllUsersVotingPowerJob < ApplicationJob
  class UserVotingPowerUpdateError < StandardError; end

  queue_as :default

  def perform
    Authentication::UserReadModel.find_each do |user|
      Gamification::UpdateVotingPowerService.new.call(user_id: user.user_id)
    rescue => e
      error_message = "Failed to update voting power for user #{user.user_id}: #{e.message}"
      Rails.logger.error error_message

      Appsignal.send_error(UserVotingPowerUpdateError.new(error_message)) do |transaction|
        transaction.set_namespace("background_job")
        transaction.set_tags(
          job: self.class.name,
          queue: queue_name
        )
        transaction.set_params(
          user_id: user.user_id,
          original_error: e.class.name
        )
      end
      next
    end
  end
end
