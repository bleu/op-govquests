require "rails_helper"

RSpec.describe "Quest Completion E2E", type: :request do
  let(:user) { create(:user) }
  let(:action) { create(:action_read_model) }
  let(:quest) { create(:quest_read_model) }
  let(:quest_action) { create(:quest_action_read_model, quest: quest, action: action) }

  it "completes a quest and claims rewards" do
    get "/quests/#{quest.quest_id}"
    expect(response).to have_http_status(:ok)
    quest_data = JSON.parse(response.body)
    expect(quest_data["status"]).to eq("created")

    # Start completing action
    post "/actions/#{action.id}/start"
    expect(response).to have_http_status(:ok)
    start_data = JSON.parse(response.body)
    completion_token = start_data["token"]

    # Complete action (for read_document, just mark as read)
    post "/actions/#{action.id}/complete",
      params: {token: completion_token, completion_data: {read: true}}

    expect(response).to have_http_status(:ok)

    # Query quest status
    get "/quests/#{quest.quest_id}"
    expect(response).to have_http_status(:ok)
    quest_data = JSON.parse(response.body)
    expect(quest_data["status"]).to eq("active")

    # Query points balance
    get "/users/#{user.id}/points"
    expect(response).to have_http_status(:ok)
    points_data = JSON.parse(response.body)
    expect(points_data["balance"]).to eq(100)  # Assuming initial balance was 0

    # Check available rewards
    get "/users/#{user.id}/available_rewards"
    expect(response).to have_http_status(:ok)
    rewards_data = JSON.parse(response.body)
    expect(rewards_data["rewards"]).not_to be_empty

    # Claim rewards
    post "/users/#{user.id}/claim_rewards"
    expect(response).to have_http_status(:ok)

    # Check user's reward inventory
    get "/users/#{user.id}/reward_inventory"
    expect(response).to have_http_status(:ok)
    inventory_data = JSON.parse(response.body)
    expect(inventory_data["inventory"]).not_to be_empty
  end
end
