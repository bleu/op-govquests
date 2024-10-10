module Types
  class UserType < Types::BaseObject
    field :id, ID, null: false, method: :user_id
    field :email, String, null: true
    field :user_type, String, null: false
    field :address, String, null: false
    field :chain_id, Integer, null: false
  end
end
