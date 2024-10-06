require "rails_helper"

RSpec.describe QuestsController, type: :controller do
  let(:quest) { create(:quest_read_model) }
  let(:action) { create(:action_read_model) }

  before do
    create(:quest_action_read_model, quest: quest, action: action)
  end

  describe "GET #index" do
    it "returns a successful response" do
      get :index
      expect(response).to have_http_status(:success)
    end

    it "returns correct number of quests" do
      get :index
      quests = JSON.parse(response.body)
      expect(quests.length).to eq(1)
      expect(quests.first["id"]).to eq(quest.quest_id)
    end
  end

  describe "GET #show" do
    it "returns a successful response for existing quest" do
      get :show, params: {id: quest.quest_id}
      expect(response).to have_http_status(:success)
    end

    it "returns correct quest details" do
      get :show, params: {id: quest.quest_id}
      quest_response = JSON.parse(response.body)
      expect(quest_response["id"]).to eq(quest.quest_id)
      expect(quest_response["actions"].length).to eq(1)
      expect(quest_response["actions"].first["id"]).to eq(action.action_id)
    end

    it "returns not found for non-existent quest" do
      get :show, params: {id: "non_existent_id"}
      expect(response).to have_http_status(:not_found)
    end
  end
end
