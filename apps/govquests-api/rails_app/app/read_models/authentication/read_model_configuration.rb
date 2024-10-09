module Authentication
  class UserReadModel < ApplicationRecord
    self.table_name = "users"

    validates :user_id, presence: true, uniqueness: true
    validates :email, uniqueness: true, format: {with: URI::MailTo::EMAIL_REGEXP}, allow_nil: true
    validates :user_type, presence: true, inclusion: {in: %w[delegate non_delegate]}

    # serialize :wallets, coder: JSON

    def self.find(address, chain_id)
      where("wallets @> ?", [{wallet_address: address, chain_id: chain_id.to_i}].to_json).first
    end

    def self.authenticate_with_siwe(message, signature)
      siwe_message = Siwe::Message.new(
        message[:domain],
        message[:address],
        message[:uri],
        message[:version],
        {
          statement: message[:statement],
          issued_at: message[:issuedAt],
          nonce: message[:nonce],
          chain_id: message[:chainId].to_i,
          expiration_time: "",
          not_before: "",
          request_id: "",
          resources: []
        }
      )

      if siwe_message.verify(signature, message[:domain], nil, message[:nonce])
        find(siwe_message.address, siwe_message.chain_id)
      end
    end
  end

  class SessionReadModel < ApplicationRecord
    self.table_name = "user_sessions"

    validates :user_id, presence: true
    validates :session_token, presence: true, uniqueness: true
    validates :logged_in_at, presence: true
  end

  class ReadModelConfiguration
    def call(event_store)
      event_store.subscribe(OnUserRegistered.new, to: [Authentication::UserRegistered])
      event_store.subscribe(OnUserLoggedIn.new, to: [Authentication::UserLoggedIn])
    end
  end
end
