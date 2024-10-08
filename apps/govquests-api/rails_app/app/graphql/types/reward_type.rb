module Types
  class RewardType < Types::BaseObject
    field :type, String, null: false
    field :amount, Integer, null: false
  end
end
