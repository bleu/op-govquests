# rails_app/test/integration/user_quest_reward_flow_test.rb
require "test_helper"

class UserQuestRewardFlowTest < IntegrationTest
  test "user completes quest and earns rewards" do
    # Setup: Create user, actions, and quest
    user_id = SecureRandom.uuid
    post "/register", params: {
      user_id: user_id,
      email: "user2@example.com",
      user_type: "delegate",
      wallet_address: "0xFEDCBA0987654321",
      chain_id: 1
    }
    assert_response :success

    quest_id = SecureRandom.uuid
    post "/quests", params: {
      quest_id: quest_id,
      title: "Governance 101",
      intro: "Learn the basics of governance",
      quest_type: "Onboarding",
      audience: "AllUsers",
      rewards: [{type: "points", amount: 50}]
    }
    assert_response :success

    action1_id = SecureRandom.uuid
    post "/actions", params: {
      action_id: action1_id,
      content: "Read the Governance Policy",
      action_type: "ReadDocument",
      completion_criteria: {document_url: "https://example.com/governance"}
    }
    assert_response :success

    action2_id = SecureRandom.uuid
    post "/actions", params: {
      action_id: action2_id,
      content: "Vote on Proposal",
      action_type: "Vote",
      completion_criteria: {proposal_id: "proposal_123"}
    }
    assert_response :success

    post "/quests/#{quest_id}/actions", params: {
      action_id: action1_id,
      position: 1
    }
    assert_response :success

    post "/quests/#{quest_id}/actions", params: {
      action_id: action2_id,
      position: 2
    }
    assert_response :success

    # User starts the quest
    post "/quests/#{quest_id}/start", params: {user_id: user_id}
    assert_response :success
    assert_equal 1, UserQuest.count

    user_quest = UserQuest.find_by(quest_id: quest_id, user_id: user_id)
    assert_not_nil user_quest
    assert_equal "started", user_quest.status

    # User completes first action
    post "/actions/execute", params: {
      action_id: action1_id,
      user_id: user_id,
      timestamp: Time.current,
      completion_data: {result: "success"}
    }
    assert_response :success
    assert_equal 1, ActionLogReadModel.count

    # User completes second action
    post "/actions/execute", params: {
      action_id: action2_id,
      user_id: user_id,
      timestamp: Time.current,
      completion_data: {result: "success"}
    }
    assert_response :success
    assert_equal 2, ActionLogReadModel.count

    # Verify quest completion and reward issuance
    # Assuming completing all actions in a quest triggers reward creation
    # This might require observing emitted events or checking read models

    # Check GameProfile for earned points
    game_profile = GameProfileReadModel.find_by(profile_id: user_id)
    assert_not_nil game_profile
    assert_equal 50, game_profile.score

    # Check Reward issuance
    reward = RewardReadModel.find_by(issued_to: user_id)
    assert_not_nil reward
    assert_equal "points", reward.reward_type
    assert_equal 50, reward.value
    assert_equal "Issued", reward.delivery_status

    # Check Badge earning (if applicable)
    # This depends on your gamification rules
    # Example:
    # assert_includes game_profile.badges, "First Quest Completed"
  end
end
