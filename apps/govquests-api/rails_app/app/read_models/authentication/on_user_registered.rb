# app/read_models/client_authentication/create_user.rb
module Authentication
  class OnUserRegistered
    def call(event)
      user_id = event.data.fetch(:user_id)
      email = event.data.fetch(:email)
      user_type = event.data.fetch(:user_type)
      wallet_address = event.data.fetch(:wallet_address)
      chain_id = event.data.fetch(:chain_id)

      UserReadModel.find_or_create_by(user_id: user_id).update(
        email: email,
        user_type: user_type,
        wallets: [ { wallet_address: wallet_address, chain_id: chain_id } ]
      )
    end
  end
end
