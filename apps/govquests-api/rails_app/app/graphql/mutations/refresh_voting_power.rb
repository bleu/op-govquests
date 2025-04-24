module Mutations
  class RefreshVotingPower < BaseMutation
    field :voting_power, Types::VotingPowerType, null: true
    field :errors, [String], null: false

    def resolve
      user_id = context[:current_user].user_id

      unless user_id
        return {voting_power: nil, errors: ["User not found"]}
      end

      voting_power = Gamification::UpdateVotingPowerService.new.call(user_id: user_id)

      {
        voting_power:,
        errors: []
      }
    rescue => e
      {
        voting_power: nil,
        errors: [e.message]
      }
    end
  end
end
