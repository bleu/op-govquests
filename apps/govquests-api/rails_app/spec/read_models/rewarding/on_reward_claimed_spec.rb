require "rails_helper"

RSpec.describe Rewarding::OnRewardClaimed do
  let(:handler) { described_class.new }
  let(:reward_id) { SecureRandom.uuid }
  let(:user_id) { SecureRandom.uuid }

  before do
    Rewarding::RewardReadModel.create!(
      reward_id: reward_id,
      reward_type: "points",
      value: 100,
      delivery_status: "Issued",
      issued_to: user_id,
      claimed: false
    )
  end

  describe "#call" do
    it "updates reward status to claimed when handling RewardClaimed event" do
      event = Rewarding::RewardClaimed.new(data: {
        reward_id: reward_id,
        user_id: user_id
      })

      handler.call(event)

      reward = Rewarding::RewardReadModel.find_by(reward_id: reward_id)
      expect(reward.claimed).to be true
      expect(reward.delivery_status).to eq("Claimed")
    end
  end
end
