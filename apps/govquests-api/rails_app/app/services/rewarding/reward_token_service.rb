module Rewarding
  TOKEN_TRANSFER_REQUEST_NAMESPACE_UUID = "af0a3e0a-8641-4021-b59a-2320dee99b32"

  class RewardTokenService
    def self.call(pool_id:, user_id:, amount:)
      user = Authentication::UserReadModel.find_by(user_id: user_id)

      return {error: "User not found"} unless user

      uuid = generate_uuid(pool_id: pool_id, user_id: user_id)

      TokenTransferRequestMailer.with(
        user_address: user.address,
        amount: amount,
        uuid: uuid
      ).request.deliver_now
    end

    def self.generate_uuid(pool_id:, user_id:)
      Digest::UUID.uuid_v5(TOKEN_TRANSFER_REQUEST_NAMESPACE_UUID, "#{pool_id}-#{user_id}")
    end
  end
end
