module ClientAuthentication
  class CreateAccount
    def call(event)
      account_id = event.data.fetch(:account_id)
      Account.find_or_create_by(account_id: account_id).update(
        address: event.data.fetch(:address),
        chain_id: event.data.fetch(:chain_id)
      )
    end
  end
end
