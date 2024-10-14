module Types
  class GitcoinScoreCompletionDataInput < Types::BaseInputObject
    description "Completion data for Gitcoin Score action"

    argument :address, String, required: true
    argument :signature, String, required: true
    argument :nonce, String, required: true
  end
end
