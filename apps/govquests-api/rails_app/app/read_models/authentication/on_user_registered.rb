module Authentication
  class OnUserRegistered
    def call(event)
      user_id = event.data.fetch(:user_id)
      email = event.data.fetch(:email)
      user_type = event.data.fetch(:user_type)
      wallet_address = event.data.fetch(:wallet_address)
      chain_id = event.data.fetch(:chain_id)

      user = UserReadModel.find_or_initialize_by(user_id: user_id)
      user.email = email
      user.user_type = user_type
      user.wallets = [{wallet_address: wallet_address, chain_id: chain_id}]
      user.save!
    end
  end
end
