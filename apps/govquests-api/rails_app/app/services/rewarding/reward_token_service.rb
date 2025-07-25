module Rewarding
  TOKEN_TRANSFER_REQUEST_NAMESPACE_UUID = "af0a3e0a-8641-4021-b59a-2320dee99b32"

  class RewardTokenService
    def self.call(pool_id:, user_id:, amount:)
      user = Authentication::UserReadModel.find_by(user_id: user_id)

      return {error: "User not found"} unless user

      TokenTransferMailer.with(
        user_address: user.address,
        amount: amount,
        user_id: user_id,
        pool_id: pool_id
      ).request_transfer.deliver_now
    end
  end
end
