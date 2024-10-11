require "rails_helper"

RSpec.describe Questing::OnActionAssociatedWithQuest do
  let(:handler) { described_class.new }
  let(:quest_id) { SecureRandom.uuid }
  let(:action_id) { SecureRandom.uuid }
  let(:position) { 1 }

  before do
    create_quest(
      quest_id: quest_id,
      rewards: [
        {"foo" => "bar", "amount" => 100}
      ],
      title: "Test Quest",
      quest_type: "Test",
      audience: "All"
    )

    create_action(action_id: action_id, display_data: {
      title: "Read Document 1"
    }, action_type: "read_document", action_data: {foo: "bar"})
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
