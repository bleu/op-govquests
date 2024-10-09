module Authentication
  class UserReadModel < ApplicationRecord
    self.table_name = "users"

    validates :user_id, presence: true, uniqueness: true
    validates :email, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }, allow_nil: true
    validates :user_type, presence: true, inclusion: { in: %w[delegate non_delegate] }
    
    serialize :wallets, coder: JSON

    def self.find(address, chain_id)
      find_by(wallets: [{ wallet_address: address, chain_id: chain_id }]) do |user|
        user.user_id = SecureRandom.uuid
        user.user_type = 'non_delegate'
      end
    end

    def self.authenticate_with_siwe(message, signature)
      siwe_message = Siwe::Message.from_message(message)
      if siwe_message.valid_signature?(signature)
        user = find(siwe_message.address, siwe_message.chain_id)
        user
      else
        nil
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
