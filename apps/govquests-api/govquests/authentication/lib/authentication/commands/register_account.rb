module Authentication
  class RegisterAccount < Infra::Command
    attribute :account_id, Infra::Types::UUID
    attribute :address, Infra::Types::String
    attribute :chain_id, Infra::Types::Value

    alias aggregate_id account_id
  end
end
