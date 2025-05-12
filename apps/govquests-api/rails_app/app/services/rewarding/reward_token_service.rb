module Rewarding
  class RewardTokenService
    def self.call(pool_id:, user_id:, amount:)
      user = Authentication::UserReadModel.find_by(user_id: user_id)

      {error: "User not found"} unless user

      # TODO: Implement - send email to admin for transaction request
    end
  end
end
