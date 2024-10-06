require_relative "test_helper"

module Authentication
  class UserTest < Test
    cover "Authentication::User"

    def setup
      super
      @user_id = SecureRandom.uuid
      @user = User.new(@user_id)
    end

    def test_register_a_new_user
      email = "test@example.com"
      user_type = "delegate"
      wallet_address = "0x1234567890abcdef"
      chain_id = 1

      @user.register(email, user_type, wallet_address, chain_id)

      assert_equal 1, @user.unpublished_events.size
      event = @user.unpublished_events.first
      assert_instance_of UserRegistered, event
      assert_equal @user_id, event.data[:user_id]
      assert_equal email, event.data[:email]
      assert_equal user_type, event.data[:user_type]
      assert_equal wallet_address, event.data[:wallet_address]
      assert_equal chain_id, event.data[:chain_id]
    end

    def test_cannot_register_an_already_registered_user
      @user.register("test@example.com", "delegate", "0x1234567890abcdef", 1)

      assert_raises(User::AlreadyRegistered) do
        @user.register("new@example.com", "non_delegate", "0x0987654321fedcba", 2)
      end
    end

    def test_log_in_a_registered_user
      @user.register("test@example.com", "delegate", "0x1234567890abcdef", 1)
      session_token = SecureRandom.hex(16)
      timestamp = Time.now

      @user.log_in(session_token, timestamp)

      assert_equal 2, @user.unpublished_events.size
      event = @user.unpublished_events.to_a.last
      assert_instance_of UserLoggedIn, event
      assert_equal @user_id, event.data[:user_id]
      assert_equal session_token, event.data[:session_token]
      assert_equal timestamp, event.data[:timestamp]
    end

    def test_cannot_log_in_an_unregistered_user
      session_token = SecureRandom.hex(16)
      timestamp = Time.now

      error = assert_raises(RuntimeError) do
        @user.log_in(session_token, timestamp)
      end
      assert_equal "User not registered", error.message
    end
  end
end
