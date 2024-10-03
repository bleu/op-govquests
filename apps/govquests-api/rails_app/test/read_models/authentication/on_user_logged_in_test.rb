require "test_helper"

module Authentication
  class OnUserLoggedInTest < ActiveSupport::TestCase
    def setup
      @handler = Authentication::OnUserLoggedIn.new
      @user_id = SecureRandom.uuid
      @session_token = SecureRandom.hex(16)
      @timestamp = Time.current
    end

    test "creates a new user session when handling UserLoggedIn event" do
      event = UserLoggedIn.new(data: {
        user_id: @user_id,
        session_token: @session_token,
        timestamp: @timestamp
      })

      assert_difference "SessionReadModel.count", 1 do
        @handler.call(event)
      end

      session = ::Authentication::SessionReadModel.last
      assert_equal @user_id, session.user_id
      assert_equal @session_token, session.session_token
      assert_equal @timestamp, session.logged_in_at
      assert_nil session.logged_out_at
    end
  end
end
