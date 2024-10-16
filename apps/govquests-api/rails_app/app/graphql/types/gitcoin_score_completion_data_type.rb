module Types
  class GitcoinScoreCompletionDataType < Types::BaseObject
    implements Types::CompletionDataInterface
    description "Completion data for Gitcoin Score action"

    field :score, Float, null: false
    field :verified, Boolean, null: false
    field :passed_threshold, Boolean, null: false

    def action_type
      "gitcoin_score"
    end
  end
end
