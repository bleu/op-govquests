module Types
  class GitcoinScoreActionDataType < Types::BaseObject
    implements Types::ActionDataInterface
    description "Action data for Gitcoin Score action"

    field :min_score, Integer, null: false

    def action_type
      "gitcoin_score"
    end
  end
end
