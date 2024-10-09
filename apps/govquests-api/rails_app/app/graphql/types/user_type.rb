module Types
  class UserType < Types::BaseObject
    field :id, ID, null: false, method: :user_id
    field :email, String, null: true
    field :user_type, String, null: false
    field :wallets, [Types::WalletType], null: false
  end
end
