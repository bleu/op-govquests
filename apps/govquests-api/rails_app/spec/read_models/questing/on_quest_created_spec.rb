require "rails_helper"

RSpec.describe Questing::OnQuestCreated do
  let(:handler) { described_class.new }
  let(:quest_id) { SecureRandom.uuid }
  let(:title) { "Governance 101" }
  let(:intro) { "Learn about governance basics" }
  let(:audience) { "AllUsers" }

  describe "#call" do
    it "creates a new quest when handling QuestCreated event" do
      event = Questing::QuestCreated.new(data: {
        quest_id: quest_id,
        display_data: {
          title: title,
          intro: intro
        },
        audience: audience
      })

      expect {
        handler.call(event)
      }.to change(Questing::QuestReadModel, :count).by(1)

      quest = Questing::QuestReadModel.find_by(quest_id: quest_id)
      expect(quest.display_data).to eq({
        "title" => title,
        "intro" => intro
      })
      expect(quest.audience).to eq(audience)
      expect(quest.status).to eq("created")
    end
  end
end
