module Types
  class RewardDefinitionType < Types::BaseObject
    field :type, String, null: false
    field :amount, Integer, null: false
  end

  class RewardPoolType < Types::BaseObject
    field :reward_definition, RewardDefinitionType, null: false
    field :remaining_inventory, Integer, null: true
  end
end
