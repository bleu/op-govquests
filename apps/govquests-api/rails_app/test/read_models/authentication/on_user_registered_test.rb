require "test_helper"

module Authentication
  class OnUserRegisteredTest < ActiveSupport::TestCase
    def setup
      @handler = Authentication::OnUserRegistered.new
      @user_id = SecureRandom.uuid
      @email = "test@example.com"
      @user_type = "non_delegate"
      @wallet_address = "0x1234567890abcdef"
      @chain_id = 1
    end

    test "creates a new user when handling UserRegistered event" do
      event = UserRegistered.new(data: {
        user_id: @user_id,
        email: @email,
        user_type: @user_type,
        wallet_address: @wallet_address,
        chain_id: @chain_id
      })

      assert_difference -> { UserReadModel.count }, 1 do
        @handler.call(event)
      end

      user = UserReadModel.find_by(user_id: @user_id)
      assert_equal @email, user.email
      assert_equal @user_type, user.user_type
      assert_equal @wallet_address, user.wallets.first["wallet_address"]
      assert_equal @chain_id, user.wallets.first["chain_id"]
    end

    test "updates existing user when handling UserRegistered event" do
      existing_user = UserReadModel.new(
        user_id: @user_id,
        email: "old@example.com",
        user_type: "delegate",
        wallets: [{wallet_address: "0x0987654321fedcba", chain_id: 2}]
      )
      existing_user.save!

      event = UserRegistered.new(data: {
        user_id: @user_id,
        email: @email,
        user_type: @user_type,
        wallet_address: @wallet_address,
        chain_id: @chain_id
      })

      assert_no_difference -> { UserReadModel.count } do
        @handler.call(event)
      end

      existing_user.reload
      assert_equal @email, existing_user.email
      assert_equal @user_type, existing_user.user_type
      assert_equal @wallet_address, existing_user.wallets.first["wallet_address"]
      assert_equal @chain_id, existing_user.wallets.first["chain_id"]
    end

    test "does not create duplicate users when handling UserRegistered event" do
      existing_user = UserReadModel.create!(
        user_id: @user_id,
        email: @email,
        user_type: @user_type,
        wallets: [{wallet_address: @wallet_address, chain_id: @chain_id}]
      )

      event = UserRegistered.new(data: {
        user_id: @user_id,
        email: @email,
        user_type: @user_type,
        wallet_address: @wallet_address,
        chain_id: @chain_id
      })

      assert_no_difference "UserReadModel.count" do
        @handler.call(event)
      end

      existing_user.reload
      assert_equal @email, existing_user.email
    end
  end
end
