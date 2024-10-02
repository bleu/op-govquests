require_relative "test_helper"

module Authentication
  class RegisterUserTest < Test
    cover "Authentication*"

    def setup
      @user_id = SecureRandom.uuid
      @email = "user@example.com"
      @chain_id = 1
      @user_type = "delegate"
      @data = {user_id: @user_id, email: @email, user_type: @user_type}
    end

    def test_user_should_get_registered
      user_registered = UserRegistered.new(data: @data)
      assert_events("Authentication::User$#{@user_id}", user_registered) do
        register_user(@user_id, @email, @chain_id, @user_type)
      end
    end

    def test_should_not_allow_double_registration
      assert_raises(User::AlreadyRegistered) do
        register_user(@user_id, @email, @chain_id, @user_type)
        register_user(@user_id, @email, @chain_id, @user_type)
      end
    end

    private

    def register_user(user_id, email, chain_id, user_type)
      run_command(RegisterUser.new(user_id: user_id, address: "0x123", chain_id: chain_id, email: email, user_type: user_type))
    end
  end
end
