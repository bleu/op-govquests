module Types
  class WalletType < Types::BaseObject
    field :address, String, null: false
    field :chain_id, Integer, null: false
  end
end
