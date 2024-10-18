module Types
  class GitcoinScoreStartDataInput < BaseInputObject
    description "Start data for Gitcoin Score action"

    argument :action_type, String, required: true
  end
end
