require "test_helper"

module ClientAuthentication
  class CreateTest < InMemoryTestCase
    cover "Authentication*"

    def setup
      super
      ClientAuthentication::User.destroy_all
    end

    def test_set_create
      user_id = SecureRandom.uuid
      address = "0x"
      chain_id = 1

      run_command(
        Authentication::RegisterUser.new(
          user_id: user_id,
          address: address,
          chain_id: chain_id
        )
      )

      user = ClientAuthentication::User.find_by(user_id: user_id, address: address, chain_id: chain_id)
      assert user.present?
    end

    private

    def event_store
      Rails.configuration.event_store
    end
  end
end
