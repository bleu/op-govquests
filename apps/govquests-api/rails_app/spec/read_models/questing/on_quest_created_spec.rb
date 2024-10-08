require "rails_helper"

RSpec.describe Questing::OnQuestCreated do
  let(:handler) { described_class.new }
  let(:quest_id) { SecureRandom.uuid }
  let(:title) { "Governance 101" }
  let(:intro) { "Learn about governance basics" }
  let(:quest_type) { "Onboarding" }
  let(:audience) { "AllUsers" }
  let(:rewards) { [{"type" => "Points", "amount" => 50}] }

  describe "#call" do
    it "creates a new quest when handling QuestCreated event" do
      event = Questing::QuestCreated.new(data: {
        quest_id: quest_id,
        display_data: {
          title: title,
          intro: intro
        },
        quest_type: quest_type,
        audience: audience,
        rewards: rewards
      })

      expect {
        handler.call(event)
      }.to change(Questing::QuestReadModel, :count).by(1)

      quest = Questing::QuestReadModel.find_by(quest_id: quest_id)
      expect(quest.display_data).to eq({
        "title" => title,
        "intro" => intro
      })
      expect(quest.quest_type).to eq(quest_type)
      expect(quest.audience).to eq(audience)
      expect(quest.rewards).to eq(rewards)
      expect(quest.status).to eq("created")
    end
  end
end
