require "test_helper"

module ClientAuthentication
  class CreateTest < InMemoryTestCase
    cover "Authentication*"

    def setup
      super
      ClientAuthentication::Account.destroy_all
    end

    def test_set_create
      account_id = SecureRandom.uuid
      address = "0x"
      chain_id = 1


      run_command(
        Authentication::RegisterAccount.new(
          account_id: account_id,
          address: address,
          chain_id: chain_id
        )
      )

      account = ClientAuthentication::Account.find_by(account_id: account_id, address: address, chain_id: chain_id)
      assert account.present?
    end

    private

    def event_store
      Rails.configuration.event_store
    end
  end
end
