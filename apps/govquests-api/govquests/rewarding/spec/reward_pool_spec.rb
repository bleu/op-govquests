require "spec_helper"
require "pry"

RSpec.describe Rewarding::RewardPool do
  let(:pool_id) { SecureRandom.uuid }
  let(:quest_id) { SecureRandom.uuid }
  let(:user_id) { SecureRandom.uuid }
  let(:other_user_id) { SecureRandom.uuid }
  let(:pool) { described_class.new(pool_id) }

  RSpec.shared_examples "issuable reward" do |reward_type, reward_definition, initial_inventory|
    context "with #{reward_type} reward" do
      before do
        pool.create(
          quest_id: quest_id,
          reward_definition: reward_definition,
          initial_inventory: initial_inventory
        )
      end

      it "emits RewardIssued event" do
        pool.issue_reward(user_id)

        events = pool.unpublished_events.select { |event| event.is_a?(Rewarding::RewardIssued) }
        expect(events.size).to eq(1)
        event = events.last

        expect(event).to be_a(Rewarding::RewardIssued)
        expect(event.data[:pool_id]).to eq(pool_id)
        expect(event.data[:user_id]).to eq(user_id)
        expect(event.data[:reward_definition]).to eq(reward_definition)
        expect(event.data[:issued_at]).to be_a(Time)
      end

      if reward_type == "Points"
        it "allows multiple issuances to the same user" do
          pool.issue_reward(user_id)
          expect { pool.issue_reward(user_id) }.not_to raise_error

          events = pool.unpublished_events.select { |event| event.is_a?(Rewarding::RewardIssued) }
          expect(events.size).to eq(2)
        end
      end

      if reward_type == "Token"
        it "emits RewardIssued event and decrements inventory" do
          pool.issue_reward(user_id)

          events = pool.unpublished_events.select { |event| event.is_a?(Rewarding::RewardIssued) }
          expect(events.size).to eq(1)
          event = events.last

          expect(event).to be_a(Rewarding::RewardIssued)
          expect(event.data[:pool_id]).to eq(pool_id)
          expect(event.data[:user_id]).to eq(user_id)
          expect(event.data[:reward_definition]).to eq(reward_definition)
          expect(event.data[:issued_at]).to be_a(Time)

          expect(pool.instance_variable_get(:@remaining_inventory)).to eq(initial_inventory - reward_definition["amount"])
        end

        it "raises InsufficientInventory when inventory is depleted" do
          pool.issue_reward(user_id)
          expect(pool.instance_variable_get(:@remaining_inventory)).to eq(initial_inventory - reward_definition["amount"])
          expect(pool.instance_variable_get(:@remaining_inventory)).to be 0
          expect {
            pool.issue_reward(other_user_id)
          }.to raise_error(Rewarding::RewardPool::InsufficientInventory)
        end

        it "raises AlreadyIssued when issued twice to the same user" do
          pool.issue_reward(user_id)

          expect {
            pool.issue_reward(user_id)
          }.to raise_error(Rewarding::RewardPool::AlreadyIssued)
        end
      end
    end
  end

  describe "#issue_reward" do
    it_behaves_like "issuable reward", "Points", {"type" => "Points", "amount" => 100, "token_address" => nil}
    it_behaves_like "issuable reward", "Token", {"type" => "Token", "amount" => 1, "token_address" => "0xabc"}, 1

    context "issuing reward before creating pool" do
      it "raises NotIssued error" do
        expect {
          pool.issue_reward(user_id)
        }.to raise_error(Rewarding::RewardPool::NotIssued)
      end
    end
  end

  describe "#create" do
    context "when creating a points reward pool" do
      it "creates a RewardPoolCreated event with correct data" do
        pool.create(quest_id: quest_id, reward_definition: SharedKernel::Types::RewardDefinition.new(type: "Points", amount: 100))

        events = pool.unpublished_events.to_a
        expect(events.size).to eq(1)
        event = events.first

        expect(event).to be_a(Rewarding::RewardPoolCreated)
        expect(event.data[:pool_id]).to eq(pool_id)
        expect(event.data[:quest_id]).to eq(quest_id)
        expect(event.data[:reward_definition]).to include({"type" => "Points", "amount" => 100})
        expect(event.data[:initial_inventory]).to be_nil
      end
    end

    context "with token reward and inventory" do
      it "emits RewardPoolCreated event with inventory" do
        pool.create(
          quest_id: quest_id,
          reward_definition: SharedKernel::Types::RewardDefinition.new(type: "Token", amount: 1, token_address: "0xabc"),
          initial_inventory: 900
        )

        events = pool.unpublished_events.to_a
        expect(events.size).to eq(1)
        event = events.first

        expect(event).to be_a(Rewarding::RewardPoolCreated)
        expect(event.data[:pool_id]).to eq(pool_id)
        expect(event.data[:quest_id]).to eq(quest_id)
        expect(event.data[:reward_definition]).to eq({"type" => "Token", "amount" => 1, "token_address" => "0xabc"})
        expect(event.data[:initial_inventory]).to eq(900)
      end
    end

    context "when creating an already created pool" do
      before do
        pool.create(quest_id: quest_id, reward_definition: SharedKernel::Types::RewardDefinition.new(type: "Points", amount: 100))
      end

      it "raises AlreadyCreated error" do
        expect {
          pool.create(quest_id: quest_id, reward_definition: SharedKernel::Types::RewardDefinition.new(type: "Points", amount: 100))
        }.to raise_error(Rewarding::RewardPool::AlreadyCreated)
      end
    end
  end

  describe "edge cases" do
    it "raises AlreadyCreated when attempting to create a pool twice with different definitions" do
      pool.create(quest_id: quest_id, reward_definition: SharedKernel::Types::RewardDefinition.new(type: "Points", amount: 100))

      expect {
        pool.create(quest_id: quest_id, reward_definition: SharedKernel::Types::RewardDefinition.new(type: "Token", amount: 1, token_address: "0xabc"))
      }.to raise_error(Rewarding::RewardPool::AlreadyCreated)
    end

    it "handles zero initial inventory gracefully" do
      pool.create(quest_id: quest_id, reward_definition: SharedKernel::Types::RewardDefinition.new(type: "Token", amount: 1, token_address: "0xabc"), initial_inventory: 0)

      expect(pool.instance_variable_get(:@remaining_inventory)).to eq(0)
    end
  end
end
