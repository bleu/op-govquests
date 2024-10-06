require "rails_helper"
RSpec.describe QuestsController, type: :controller do
  include InMemoryRESIntegrationCase

  let(:quest) { create_quest }
  let(:action) { create_action }

  before do
    associate_action_with_quest(quest.quest_id, action.action_id)
  end

  describe "GET #show" do
    it "returns correct quest details" do
      get :show, params: {id: quest.quest_id}
      quest_response = JSON.parse(response.body)
      expect(quest_response["id"]).to eq(quest.quest_id)
      expect(quest_response["title"]).to eq(quest.display_data["title"])
      expect(quest_response["intro"]).to eq(quest.display_data["intro"])
      expect(quest_response["actions"]).to be_an(Array)
      expect(quest_response["actions"].length).to eq(1)
      expect(quest_response["actions"].first["id"]).to eq(action.action_id)
    end
  end

  def create_quest
    quest_id = SecureRandom.uuid
    command = Questing::CreateQuest.new(
      quest_id: quest_id,
      display_data: {title: "Test Quest", intro: "Test Intro"},
      quest_type: "Standard",
      audience: "AllUsers",
      rewards: [{type: "Points", amount: 50}]
    )
    run_command(command)
    Questing::QuestReadModel.find_by(quest_id: quest_id)
  end

  def create_action
    action_id = SecureRandom.uuid
    command = ActionTracking::CreateAction.new(
      action_id: action_id,
      action_type: "read_document",
      action_data: {test: "data"},
      display_data: {content: "Test Action"}
    )
    run_command(command)
    ActionTracking::ActionReadModel.find_by(action_id: action_id)
  end

  def associate_action_with_quest(quest_id, action_id)
    command = Questing::AssociateActionWithQuest.new(
      quest_id: quest_id,
      action_id: action_id,
      position: 1
    )
    run_command(command)
  end

  def run_command(command)
    Rails.configuration.command_bus.call(command)
  end
end
