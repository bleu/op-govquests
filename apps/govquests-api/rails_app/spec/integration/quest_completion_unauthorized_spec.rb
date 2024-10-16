require "rails_helper"

RSpec.describe "Unauthorized Quest Completion", type: :request do
  # Define quest attributes
  let(:quest_title) { "Complete Onboarding" }
  let(:quest_type) { "Onboarding" }
  let(:audience) { "AllUsers" }
  let(:rewards) { [{"type" => "points", "amount" => 100}] }

  # Define action attributes
  let(:action1_attrs) do
    {
      action_type: "read_document",
      action_data: {"url" => "https://example.com/doc1"},
      display_data: {"title" => "Read Document 1"}
    }
  end

  let(:action2_attrs) do
    {
      action_type: "read_document",
      action_data: {"url" => "https://example.com/doc2"},
      display_data: {"title" => "Read Document 2"}
    }
  end

  # Create a quest and actions without authenticating a user
  let(:quest_data) do
    create_quest_with_actions(
      title: quest_title,
      quest_type: quest_type,
      audience: audience,
      rewards: rewards,
      actions: [action1_attrs, action2_attrs]
    )
  end

  # Extract quest_id and action_ids from quest_data
  let(:quest_id) { quest_data[0] }
  let(:action_ids) { quest_data[1] }

  # GraphQL Mutations
  let(:start_action_execution_mutation) do
    <<-GRAPHQL
  mutation StartActionExecution(
    $questId: ID!
    $actionId: ID!
    $actionType: String!
    $gitcoinScoreStartData: GitcoinScoreStartDataInput
    $readDocumentStartData: ReadDocumentStartDataInput
  ) {
    startActionExecution(
      input: {
        questId: $questId
        actionId: $actionId
        actionType: $actionType
        gitcoinScoreStartData: $gitcoinScoreStartData
        readDocumentStartData: $readDocumentStartData
      }
    ) {
      actionExecution {
        id
        actionId
        userId
        actionType
        startData {
          ... on GitcoinScoreStartData {
            message
            nonce
          }
        }
        status
        nonce
        startedAt
      }
      errors
    }
  }
    GRAPHQL
  end

  describe "completing actions without authentication" do
    it "fails to start action execution" do
      action_id = action_ids.first
      action_type = "read_document"

      post "/graphql", params: {query: start_action_execution_mutation, variables: {questId: quest_id, actionId: action_id, actionType: action_type}}
      json_response = JSON.parse(response.body)

      expect(json_response["data"]["startActionExecution"]).to be_nil
      expect(json_response["errors"][0]).to include({"message" => "You are not authorized to perform this action"})
    end
  end
end
