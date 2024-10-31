require "spec_helper"

RSpec.describe Rewarding::RewardPool do
  let(:pool_id) { SecureRandom.uuid }
  let(:quest_id) { SecureRandom.uuid }
  let(:user_id) { SecureRandom.uuid }
  let(:pool) { described_class.new(pool_id) }

  describe "#create" do
    let(:points_reward_definition) { {"type" => "Points", "amount" => 100} }
    let(:token_reward_definition) { {"type" => "Token", "amount" => 1} }

    context "when creating a points reward pool" do
      it "creates a RewardPoolCreated event with correct data" do
        pool.create(quest_id: quest_id, reward_definition: points_reward_definition)

        events = pool.unpublished_events.to_a
        expect(events.size).to eq(1)
        event = events.first

        expect(event).to be_a(Rewarding::RewardPoolCreated)
        expect(event.data[:pool_id]).to eq(pool_id)
        expect(event.data[:quest_id]).to eq(quest_id)
        expect(event.data[:reward_definition]).to eq(points_reward_definition)
      end
    end

    context "with token reward and inventory" do
      it "emits RewardPoolCreated event with inventory" do
        pool.create(
          quest_id: quest_id,
          reward_definition: token_reward_definition,
          initial_inventory: 1000
        )

        event = pool.unpublished_events.to_a.first
        expect(event.data[:initial_inventory]).to eq(1000)
      end
    end

    context "when creating an already created pool" do
      before do
        pool.create(quest_id: quest_id, reward_definition: points_reward_definition)
      end

      it "raises AlreadyCreated error" do
        expect {
          pool.create(quest_id: quest_id, reward_definition: points_reward_definition)
        }.to raise_error(Rewarding::RewardPool::AlreadyCreated)
      end
    end
  end

  describe "#issue_reward" do
    context "with points reward" do
      before do
        pool.create(
          quest_id: quest_id,
          reward_definition: {"type" => "Points", "amount" => 100}
        )
      end

      it "emits RewardIssued event" do
        pool.issue_reward(user_id)

        events = pool.unpublished_events.to_a
        expect(events.size).to eq(2)
        event = events.last

        expect(event).to be_a(Rewarding::RewardIssued)
        expect(event.data[:pool_id]).to eq(pool_id)
        expect(event.data[:user_id]).to eq(user_id)
        expect(event.data[:issued_at]).to be_a(Time)
      end

      it "allows multiple issuances to same user" do
        pool.issue_reward(user_id)
        expect { pool.issue_reward(user_id) }.not_to raise_error
      end
    end

    context "with token reward" do
      before do
        pool.create(
          quest_id: quest_id,
          reward_definition: {"type" => "Token", "amount" => 1},
          initial_inventory: 1
        )
      end

      it "decrements inventory on issuance" do
        pool.issue_reward(user_id)
        expect(pool.instance_variable_get(:@remaining_inventory)).to eq(0)
      end

      it "raises InsufficientInventory when depleted" do
        pool.issue_reward(user_id)
        other_user_id = SecureRandom.uuid

        expect {
          pool.issue_reward(other_user_id)
        }.to raise_error(Rewarding::RewardPool::InsufficientInventory)
      end

      it "raises AlreadyIssued when issued twice to same user" do
        pool.issue_reward(user_id)

        expect {
          pool.issue_reward(user_id)
        }.to raise_error(Rewarding::RewardPool::AlreadyIssued)
      end
    end
  end

  describe "#claim_reward" do
    before do
      pool.create(
        quest_id: quest_id,
        reward_definition: {"type" => "Points", "amount" => 100}
      )
      pool.issue_reward(user_id)
    end

    it "emits RewardClaimed event" do
      pool.claim_reward(user_id)

      events = pool.unpublished_events.to_a
      expect(events.size).to eq(3)
      event = events.last

      expect(event).to be_a(Rewarding::RewardClaimed)
      expect(event.data[:pool_id]).to eq(pool_id)
      expect(event.data[:user_id]).to eq(user_id)
    end

    context "when reward not issued" do
      it "raises NotIssued error" do
        expect {
          pool.claim_reward(SecureRandom.uuid)
        }.to raise_error(Rewarding::RewardPool::NotIssued)
      end
    end

    context "when already claimed" do
      it "raises AlreadyClaimed error" do
        pool.claim_reward(user_id)

        expect {
          pool.claim_reward(user_id)
        }.to raise_error(Rewarding::RewardPool::AlreadyClaimed)
      end
    end
  end
end
