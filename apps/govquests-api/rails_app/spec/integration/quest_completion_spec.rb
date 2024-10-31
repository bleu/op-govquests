require "rails_helper"

RSpec.describe "Quest Completion", type: :integration do
  # Define quest attributes
  let(:quest_title) { "Complete Onboarding" }
  let(:audience) { "AllUsers" }

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

  # Create a user using DomainHelpers
  let(:user_id) { create_user(email: "test@example.com", address: "0xABCDEF", chain_id: 1) }

  # Create quest and actions using a separate let block
  let(:quest_data) do
    create_quest_with_actions(
      title: quest_title,
      audience: audience,
      actions: [action1_attrs, action2_attrs]
    )
  end

  # Extract quest_id and action_ids from quest_data
  let(:quest_id) { quest_data[0] }
  let(:action_ids) { quest_data[1] }

  describe "completing all actions in a quest" do
    before do
      # Start and complete the first action
      @execution1_id = start_action_execution(user_id: user_id, action_id: action_ids[0], quest_id: quest_id)
      @nonce1 = ActionTracking::ActionExecutionReadModel.find_by(execution_id: @execution1_id).nonce
      complete_action_execution(execution_id: @execution1_id, nonce: @nonce1, completion_data: {})

      # Start and complete the second action
      @execution2_id = start_action_execution(user_id: user_id, action_id: action_ids[1], quest_id: quest_id)
      @nonce2 = ActionTracking::ActionExecutionReadModel.find_by(execution_id: @execution2_id).nonce
      complete_action_execution(execution_id: @execution2_id, nonce: @nonce2, completion_data: {})
    end

    it "marks the quest as completed for the user" do
      user_quest = Questing::UserQuestReadModel.find_by(quest_id: quest_id, user_id: user_id)
      expect(user_quest).not_to be_nil
      expect(user_quest.status).to eq("completed")
      expect(user_quest.completed_at).to be_present
    end

    # it "awards the correct number of points to the user" do
    #   # Assuming there is a PointsReadModel or similar to track user points
    #   # Replace `PointsReadModel` with the actual model you use
    #   points = PointsReadModel.find_by(user_id: user_id)
    #   expect(points).not_to be_nil
    #   expect(points.amount).to eq(100)
    # end

    # it "makes rewards available for the user to claim" do
    #   # Assuming there is a RewardReadModel or similar to track user rewards
    #   # Replace `RewardReadModel` with the actual model you use
    #   rewards = Rewarding::RewardReadModel.where(issued_to: user_id, claimed: false)
    #   expect(rewards.count).to eq(1)
    #   expect(rewards.first.value).to eq(100)
    # end
  end
end
