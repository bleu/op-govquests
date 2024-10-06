# spec/read_models/questing/on_action_associated_with_quest_spec.rb
require "rails_helper"

RSpec.describe Questing::OnActionAssociatedWithQuest do
  let(:handler) { described_class.new }
  let(:quest_id) { SecureRandom.uuid }
  let(:action_id) { SecureRandom.uuid }
  let(:position) { 1 }

  before do
    Questing::QuestReadModel.create!(quest_id: quest_id, display_data: {title: "Test Quest", intro: "Test Intro"}, quest_type: "Test", audience: "All", status: "created")
    ActionTracking::ActionReadModel.create!(action_id: action_id, display_data: {content: "Test Action"}, action_type: "Test", action_data: {foo: "bar"})
  end

  describe "#call" do
    it "associates an action with a quest when handling ActionAssociatedWithQuest event" do
      event = Questing::ActionAssociatedWithQuest.new(data: {
        quest_id: quest_id,
        action_id: action_id,
        position: position
      })

      expect {
        handler.call(event)
      }.to change(Questing::QuestActionReadModel, :count).by(1)

      quest_action = Questing::QuestActionReadModel.last
      expect(quest_action.quest_id).to eq(quest_id)
      expect(quest_action.action_id).to eq(action_id)
      expect(quest_action.position).to eq(position)
    end
  end
end
