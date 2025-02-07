module Types
  class VotingPowerType < Types::BaseObject
    field :total_voting_power, Float, null: true
    field :voting_power_relative_to_votable_supply, Float, null: true
  end
end
