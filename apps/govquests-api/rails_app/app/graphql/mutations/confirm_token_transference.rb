module Mutations
  class ConfirmTokenTransference < BaseMutation
    argument :uuid, String, required: true
    argument :transaction_hash, String, required: true

    field :success, Boolean, null: false
    field :errors, [String], null: false

    def resolve(user_id:, pool_id:, transaction_hash:)
      command = Rewarding::ConfirmTokenTransfer.new(
        user_id: user_id,
        pool_id: pool_id,
        transaction_hash: transaction_hash
      )

      begin
        Rails.configuration.command_bus.call(command)

        {
          success: true,
          errors: []
        }
      rescue Rewarding::RewardPool::NotIssued
        {
          success: false,
          errors: ["Reward pool not issued for this user"]
        }
      rescue Rewarding::RewardPool::AlreadyConfirmed
        {
          success: false,
          errors: ["Reward pool already confirmed for this user"]
        }
      end
    end
  end
end
