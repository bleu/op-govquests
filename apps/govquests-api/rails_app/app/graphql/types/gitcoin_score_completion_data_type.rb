module Types
  class GitcoinScoreCompletionDataType < Types::BaseObject
    implements Types::CompletionDataInterface
    description "Completion data for Gitcoin Score action"

    field :score, Float, null: true
    field :minimum_passing_score, Float, null: true

    def action_type
      "gitcoin_score"
    end
  end
end
