module Authentication
  class AccountRegistered < Infra::Event
    attribute :account_id, Infra::Types::UUID
    attribute :address, Infra::Types::String
    attribute :chain_id, Infra::Types::Value
  end
end
