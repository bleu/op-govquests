module Authentication
  class SiweAuthentication
    def self.verify_and_get_user(message, signature)
      siwe_message = Siwe::Message.from_message(message)
      raise Siwe::ExpiredMessage if siwe_message.expired?
      raise Siwe::NotValidMessage unless siwe_message.valid_signature?(signature)

      user = User.find_or_create_by(wallet_address: siwe_message.address) do |u|
        u.user_id = SecureRandom.uuid
        u.wallets = [{ wallet_address: siwe_message.address, chain_id: siwe_message.chain_id }]
      end

      user
    end
  end
end