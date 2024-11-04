# spec/govquests/questing/quest_spec.rb
require "spec_helper"

RSpec.describe Questing::Quest do
  let(:quest_id) { SecureRandom.uuid }
  let(:quest) { described_class.new(quest_id) }

  describe "#create" do
    context "when creating a new quest" do
      it "creates a QuestCreated event with correct data" do
        audience = "AllUsers"
        display_data = {"title" => "Governance 101", "intro" => "Learn about governance basics"}

        quest.create(display_data, audience)
        events = quest.unpublished_events.to_a

        expect(events.size).to eq(1)
        event = events.first

        expect(event).to be_a(Questing::QuestCreated)
        expect(event.data[:quest_id]).to eq(quest_id)
        expect(event.data[:display_data]).to eq(display_data)
        expect(event.data[:audience]).to eq(audience)
      end
    end

    context "when creating quest with missing fields" do
      it "sets display_data to empty hash" do
        audience = "AllUsers"
        display_data = nil

        quest.create(display_data, audience)
        event = quest.unpublished_events.first

        expect(event.data[:display_data]).to eq({})
      end
    end
  end

  describe "#associate_action" do
    context "when associating an action with the quest" do
      it "creates an ActionAssociatedWithQuest event with correct data" do
        quest.create({"title" => "Test Quest", "intro" => "Test Intro"}, "AllUsers")
        action_id = SecureRandom.uuid
        position = 1

        quest.associate_action(action_id, position)
        events = quest.unpublished_events.to_a

        expect(events.size).to eq(2)
        event = events.last

        expect(event).to be_a(Questing::ActionAssociatedWithQuest)
        expect(event.data[:quest_id]).to eq(quest_id)
        expect(event.data[:action_id]).to eq(action_id)
        expect(event.data[:position]).to eq(position)
      end
    end

    context "when associating an action before quest creation" do
      it "raises QuestNotCreatedError" do
        action_id = SecureRandom.uuid
        position = 1

        expect {
          quest.associate_action(action_id, position)
        }.to raise_error(Questing::Quest::QuestNotCreatedError)
      end
    end

    context "when associating the same action multiple times" do
      it "allows associating the same action multiple times with different positions" do
        quest.create({"title" => "Test Quest", "intro" => "Test Intro"}, "AllUsers")
        action_id = SecureRandom.uuid
        position1 = 1
        position2 = 2

        quest.associate_action(action_id, position1)
        quest.associate_action(action_id, position2)
        actions = quest.instance_variable_get(:@actions)

        expect(actions.size).to eq(2)
        expect(actions[0][:id]).to eq(action_id)
        expect(actions[0][:position]).to eq(position1)
        expect(actions[1][:id]).to eq(action_id)
        expect(actions[1][:position]).to eq(position2)
      end
    end

    context "when associating actions with different positions" do
      it "orders actions based on position" do
        quest.create({"title" => "Test Quest", "intro" => "Test Intro"}, "AllUsers")
        action_id1 = SecureRandom.uuid
        action_id2 = SecureRandom.uuid

        quest.associate_action(action_id1, 2)
        quest.associate_action(action_id2, 1)
        actions = quest.instance_variable_get(:@actions).sort_by { |a| a[:position] }

        expect(actions.first[:id]).to eq(action_id2)
        expect(actions.last[:id]).to eq(action_id1)
      end
    end
  end
end
