module Types
  class GitcoinScoreStartDataType < Types::BaseObject
    implements Types::StartDataInterface
    description "Start data for Gitcoin Score action"

    field :nonce, String, null: false
    field :message, String, null: false

    def action_type
      "gitcoin_score"
    end
  end
end
