module Gamification
  class OnTokenRewardAdded
    def call(event)
      profile = GameProfileReadModel.find_or_initialize_by(profile_id: event.data[:profile_id])
      token_address = event.data[:token_address]
      current_amount = profile.unclaimed_tokens[token_address].to_i

      profile.unclaimed_tokens = profile.unclaimed_tokens.merge(
        token_address => current_amount + event.data[:amount]
      )

      profile.save!

      Rails.logger.info "Added token reward for profile #{profile.profile_id}: #{event.data[:amount]} #{token_address}"
    end
  end
end
