# rails_app/test/integration/user_auth_flow_test.rb
require "test_helper"

class UserAuthFlowTest < IntegrationTest
  test "user registration and login" do
    # Register a new user
    post "/register", params: {
      user_id: SecureRandom.uuid,
      email: "user1@example.com",
      user_type: "non_delegate",
      wallet_address: "0xABCDEF1234567890",
      chain_id: 1
    }
    assert_response :success
    assert_equal 1, UserReadModel.count

    user = UserReadModel.find_by(email: "user1@example.com")
    assert_not_nil user
    assert_equal "non_delegate", user.user_type
    assert_equal "0xABCDEF1234567890", user.wallets.first["wallet_address"]

    # Attempt duplicate registration
    post "/register", params: {
      user_id: SecureRandom.uuid,
      email: "user1@example.com",
      user_type: "delegate",
      wallet_address: "0x1234567890ABCDEF",
      chain_id: 2
    }
    assert_response :unprocessable_entity
    assert_equal 1, UserReadModel.count # No new user created

    # Log in the user
    post "/login", params: {
      user_id: user.user_id,
      session_token: SecureRandom.hex(16),
      timestamp: Time.current
    }
    assert_response :success
    assert_equal 1, SessionReadModel.count

    session = SessionReadModel.last
    assert_equal user.user_id, session.user_id
    assert_not_nil session.session_token
    assert_nil session.logged_out_at
  end
end
