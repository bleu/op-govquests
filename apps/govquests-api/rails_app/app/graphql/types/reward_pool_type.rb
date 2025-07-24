module Types
  class RewardDefinitionType < Types::BaseObject
    field :type, String, null: false
    field :amount, Integer, null: false
  end

  class RewardPoolType < Types::BaseObject
    field :id, ID, null: false
    field :pool_id, ID, null: false
    field :reward_definition, RewardDefinitionType, null: false
    field :rewardable, Types::RewardableUnion, null: false
  end

  class RewardIssuanceType < Types::BaseObject
    field :id, ID, null: false
    field :issued_at, GraphQL::Types::ISO8601DateTime, null: false
    field :confirmed_at, GraphQL::Types::ISO8601DateTime, null: true
    field :claim_metadata, GraphQL::Types::JSON, null: true
    field :pool, RewardPoolType, null: false
    field :user, Types::UserType, null: false
  end
end
